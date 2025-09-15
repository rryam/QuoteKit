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

  /// Returns the appropriate URLSession
  static var session: URLSession {
    URLSession.shared
  }

  // MARK: - Async/Await Execution

  /// Execute a network request using modern async/await syntax
  /// - Parameter endpoint: The QuotableEndpoint to fetch data from
  /// - Returns: Decoded model of the specified type
  /// - Throws: Network or decoding errors
  static internal func execute<Model: Decodable>(
    with endpoint: QuotableEndpoint
  ) async throws -> Model {
    return try await executeRequest(with: endpoint)
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

    // Decode the response
    let decoder = JSONDecoder()
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
