//
//  QuoteKit.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

/// QuoteKit provides a Swift interface to the Quotable API
/// Uses modern async/await syntax for clean, readable networking code
public struct QuoteKit {

  // MARK: - Session Management

  /// Returns the appropriate URLSession based on environment configuration
  /// Uses insecure session if QUOTEKIT_INSECURE_SSL=1 is set (for testing only)
  static var session: URLSession {
    if ProcessInfo.processInfo.environment["QUOTEKIT_INSECURE_SSL"] == "1" {
      return URLSession(
        configuration: .default,
        delegate: InsecureSessionDelegate(),
        delegateQueue: nil
      )
    } else {
      return URLSession.shared
    }
  }

  // MARK: - Async/Await Execution

  /// Execute a network request using modern async/await syntax with automatic fallback
  /// - Parameter endpoint: The QuotableEndpoint to fetch data from
  /// - Returns: Decoded model of the specified type
  /// - Throws: Network or decoding errors
  static internal func execute<Model: Decodable>(
    with endpoint: QuotableEndpoint
  ) async throws -> Model {
    // Try the configured endpoint first
    do {
      return try await executeRequest(with: endpoint)
    } catch {
      // If the primary request fails and we're not already using the backup,
      // try the backup API automatically
      if endpoint.host.rawValue != "api.quotable.kurokeita.dev" {
        let backupEndpoint = QuotableEndpoint(
          endpoint.path,
          queryItems: endpoint.queryItems,
          host: .backup
        )

        do {
          return try await executeRequest(with: backupEndpoint)
        } catch {
          // If backup also fails, throw the original error
          throw error
        }
      } else {
        // If we were already using backup and it failed, throw the error
        throw error
      }
    }
  }

  /// Execute a single network request
  /// - Parameter endpoint: The QuotableEndpoint to fetch data from
  /// - Returns: Decoded model of the specified type
  /// - Throws: Network or decoding errors
  private static func executeRequest<Model: Decodable>(
    with endpoint: QuotableEndpoint
  ) async throws -> Model {
    let (data, response) = try await session.data(from: endpoint.url)

    // Validate HTTP response
    guard let httpResponse = response as? HTTPURLResponse,
      200...299 ~= httpResponse.statusCode
    else {
      throw QuoteFetchError.invalidResponse
    }

    // Decode the response based on the API type
    let decoder = JSONDecoder()

    // Handle different response formats
    if endpoint.host.rawValue == "api.quotable.kurokeita.dev" {
      // Backup API has different response format
      if Model.self == Quote.self {
        let backupResponse = try decoder.decode(BackupQuoteResponse.self, from: data)
        let quote = Quote(from: backupResponse.quote)
        return quote as! Model
      }
    }

    // Default decoding for original API format
    return try decoder.decode(Model.self, from: data)
  }
}

// MARK: - Pagination Helpers

public extension QuoteKit {
  /// Checks if there are more pages available in a paginated collection.
  /// - Parameter collection: Any `QuoteItemCollection` (Quotes or Authors).
  /// - Returns: `true` if there are more pages, `false` otherwise.
  static func hasMorePages<T>(_ collection: QuoteItemCollection<T>) -> Bool {
    collection.page < collection.totalPages
  }
  
  /// Gets the next page number for a paginated collection.
  /// - Parameter collection: Any `QuoteItemCollection` (Quotes or Authors).
  /// - Returns: The next page number, or nil if on the last page.
  static func nextPage<T>(_ collection: QuoteItemCollection<T>) -> Int? {
    hasMorePages(collection) ? collection.page + 1 : nil
  }
}
