//
//  File.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 03/10/21.
//

import Foundation

public extension QuoteKit {
  static func searchQuotes(for query: String,
                           limit: Int = 20,
                           page: Int = 1) async throws -> Quotes {
    try await search(path: .searchQuotes, query: query, limit: limit, page: page)
  }

  static func searchAuthors(for query: String,
                            limit: Int = 20,
                            page: Int = 1) async throws -> Authors {
    try await search(path: .searchAuthors, query: query, limit: limit, page: page)
  }

  private static func search<Model: Decodable>(path: QuotableEndpointPath,
                                               query: String,
                                               limit: Int = 20,
                                               page: Int = 1) async throws -> Model {

    let queryItems = searchParameters(query: query, limit: limit, page: page)

    return try await execute(with: QuotableEndpoint(path, queryItems: queryItems))
  }

  private static func searchParameters(query: String,
                                       limit: Int = 20,
                                       page: Int = 1) -> [URLQueryItem] {
    var queryItems: [URLQueryItem] = []

    queryItems.append(.search(query))
    queryItems.append(.limit(limit))
    queryItems.append(.page(page))

    return queryItems
  }
}
