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

  /// Execute a network request using modern async/await syntax
  /// - Parameter endpoint: The QuotableEndpoint to fetch data from
  /// - Returns: Decoded model of the specified type
  /// - Throws: Network or decoding errors
  static internal func execute<Model: Decodable>(
    with endpoint: QuotableEndpoint
  ) async throws -> Model {
    do {
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
    } catch {
      // Re-throw with more context if needed
      throw error
    }
  }
}
