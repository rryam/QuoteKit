//
//  QuoteAPIs.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 03/10/21.
//

import Foundation

public extension QuoteKit {
  /// Fetches a single quote by its unique identifier.
  /// - Parameter id: The unique identifier of the quote.
  /// - Returns: A `Quote` object containing the quote details.
  /// - Throws: An error if the network request fails or the quote is not found.
  static func quote(id: String) async throws -> Quote {
    try await execute(with: QuotableEndpoint(.quote(id)))
  }

  /// Fetches a paginated list of quotes with optional filtering and sorting.
  /// - Parameters:
  ///   - minLength: Minimum length of quote content (optional).
  ///   - maxLength: Maximum length of quote content (optional).
  ///   - tags: Array of tag names to filter by (optional).
  ///   - type: How to match tags - `.all` (match all tags) or `.either` (match any tag). Defaults to `.all`.
  ///   - authors: Array of author slugs to filter by (optional).
  ///   - sortBy: Sort quotes by a specific field (optional).
  ///   - order: Sort order - `.ascending` or `.descending` (optional).
  ///   - limit: Number of quotes per page (1-150). Defaults to 20.
  ///   - page: Page number to retrieve. Defaults to 1.
  /// - Returns: A `Quotes` collection containing the paginated results.
  /// - Throws: An error if the network request fails.
  static func quotes(minLength: Int? = nil,
                     maxLength: Int? = nil,
                     tags: [String]? = nil,
                     type: URLQueryItemListType = .all,
                     authors: [String]? = nil,
                     sortBy: QuotesSortType? = nil,
                     order: QuotableListOrder? = nil,
                     limit: Int = 20,
                     page: Int = 1) async throws -> Quotes {

    let queryItems = quotesParameter(minLength: minLength,
                                     maxLength: maxLength,
                                     tags: tags,
                                     type: type,
                                     authors: authors,
                                     sortBy: sortBy,
                                     order: order,
                                     limit: limit,
                                     page: page)

    return try await execute(with: QuotableEndpoint(.quotes, queryItems: queryItems))
  }

  static private func quotesParameter(minLength: Int? = nil,
                                      maxLength: Int? = nil,
                                      tags: [String]? = nil,
                                      type: URLQueryItemListType = .all,
                                      authors: [String]? = nil,
                                      sortBy: QuotesSortType? = nil,
                                      order: QuotableListOrder? = nil,
                                      limit: Int = 20,
                                      page: Int = 1) -> [URLQueryItem] {

    var queryItems: [URLQueryItem] = []

    queryItems.append(.limit(limit))
    queryItems.append(.page(page))

    if let minLength = minLength {
      queryItems.append(.minLength(minLength))
    }

    if let maxLength = maxLength {
      queryItems.append(.maxLength(maxLength))
    }

    if let tags = tags {
      queryItems.append(.tags(tags, type))
    }

    if let authors = authors {
      queryItems.append(.authors(authors))
    }

    if let sortBy = sortBy {
      queryItems.append(.sortQuotesBy(sortBy))
    }

    if let order = order {
      queryItems.append(.order(order))
    }

    return queryItems
  }

  /// Fetches the first page of quotes with default settings.
  /// - Returns: A `Quotes` collection containing the first 20 quotes.
  /// - Throws: An error if the network request fails.
  static func quotes() async throws -> Quotes {
    try await execute(with: QuotableEndpoint(.quotes))
  }

  /// Fetches a random quote with optional filtering criteria.
  /// - Parameters:
  ///   - minLength: Minimum length of quote content (optional).
  ///   - maxLength: Maximum length of quote content (optional).
  ///   - tags: Array of tag names to filter by (optional).
  ///   - type: How to match tags - `.all` (match all tags) or `.either` (match any tag). Defaults to `.all`.
  ///   - authors: Array of author slugs to filter by (optional).
  /// - Returns: A random `Quote` matching the specified criteria.
  /// - Throws: An error if the network request fails or no quotes match the criteria.
  static func randomQuote(minLength: Int? = nil,
                          maxLength: Int? = nil,
                          tags: [String]? = nil,
                          type: URLQueryItemListType = .all,
                          authors: [String]? = nil) async throws -> Quote {

    let queryItems = randomQuoteParameters(minLength: minLength,
                                           maxLength: maxLength,
                                           tags: tags,
                                           type: type,
                                           authors: authors)

    return try await execute(with: QuotableEndpoint(.randomQuote, queryItems: queryItems))
  }

  static private func randomQuoteParameters(minLength: Int? = nil,
                                            maxLength: Int? = nil,
                                            tags: [String]? = nil,
                                            type: URLQueryItemListType = .all,
                                            authors: [String]? = nil) -> [URLQueryItem] {

    var queryItems: [URLQueryItem] = []
    
    if let minLength = minLength {
      queryItems.append(.minLength(minLength))
    }

    if let maxLength = maxLength {
      queryItems.append(.maxLength(maxLength))
    }

    if let tags = tags {
      queryItems.append(.tags(tags, type))
    }

    if let authors = authors {
      queryItems.append(.authors(authors))
    }

    return queryItems
  }
}

// MARK: - Convenience Methods

public extension QuoteKit {
  /// Fetches today's quote of the day (a random quote).
  /// - Returns: A random `Quote` to be used as quote of the day.
  /// - Throws: An error if the network request fails.
  static func quoteOfTheDay() async throws -> Quote {
    try await randomQuote()
  }
  
  /// Fetches a short random quote (max 100 characters).
  /// - Returns: A random `Quote` with 100 characters or less.
  /// - Throws: An error if the network request fails.
  static func shortRandomQuote() async throws -> Quote {
    try await randomQuote(maxLength: 100)
  }
  
  /// Fetches quotes by a specific author using their slug.
  /// - Parameters:
  ///   - authorSlug: The author's slug identifier.
  ///   - limit: Number of quotes per page. Defaults to 20.
  ///   - page: Page number to retrieve. Defaults to 1.
  /// - Returns: A `Quotes` collection from the specified author.
  /// - Throws: An error if the network request fails.
  static func quotesByAuthor(_ authorSlug: String, limit: Int = 20, page: Int = 1) async throws -> Quotes {
    try await quotes(authors: [authorSlug], limit: limit, page: page)
  }
  
  /// Fetches all quotes from multiple authors.
  /// - Parameters:
  ///   - authorSlugs: Array of author slug identifiers.
  ///   - limit: Number of quotes per page. Defaults to 50.
  /// - Returns: A `Quotes` collection from the specified authors.
  /// - Throws: An error if the network request fails.
  static func quotesByAuthors(_ authorSlugs: [String], limit: Int = 50) async throws -> Quotes {
    try await quotes(authors: authorSlugs, limit: limit)
  }
  
  /// Fetches inspirational quotes.
  /// - Parameters:
  ///   - limit: Number of quotes per page. Defaults to 20.
  ///   - page: Page number to retrieve. Defaults to 1.
  /// - Returns: A `Quotes` collection with inspirational tags.
  /// - Throws: An error if the network request fails.
  static func inspirationalQuotes(limit: Int = 20, page: Int = 1) async throws -> Quotes {
    try await quotes(tags: ["inspirational"], limit: limit, page: page)
  }
  
  /// Fetches motivational quotes.
  /// - Parameters:
  ///   - limit: Number of quotes per page. Defaults to 20.
  ///   - page: Page number to retrieve. Defaults to 1.
  /// - Returns: A `Quotes` collection with motivational tags.
  /// - Throws: An error if the network request fails.
  static func motivationalQuotes(limit: Int = 20, page: Int = 1) async throws -> Quotes {
    try await quotes(tags: ["motivational"], limit: limit, page: page)
  }
  
  /// Fetches the most recent quotes.
  /// - Parameter limit: Number of quotes to retrieve. Defaults to 10.
  /// - Returns: A `Quotes` collection sorted by most recent first.
  /// - Throws: An error if the network request fails.
  static func recentQuotes(limit: Int = 10) async throws -> Quotes {
    try await quotes(sortBy: .dateAdded, order: .descending, limit: limit)
  }
}

// MARK: - Async Sequences

public extension QuoteKit {
  /// Creates an async sequence that automatically fetches all pages of quotes.
  /// - Parameters:
  ///   - tags: Array of tag names to filter by (optional).
  ///   - authors: Array of author slugs to filter by (optional).
  ///   - sortBy: Sort quotes by a specific field (optional).
  ///   - pageSize: Number of items per page. Defaults to 100.
  /// - Returns: An async sequence of `Quote` objects.
  @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
  static func allQuotes(
    tags: [String]? = nil,
    authors: [String]? = nil,
    sortBy: QuotesSortType? = nil,
    pageSize: Int = 100
  ) -> AsyncThrowingStream<Quote, Error> {
    AsyncThrowingStream { continuation in
      Task { @Sendable in
        var currentPage = 1
        var hasMore = true
        
        while hasMore {
          do {
            let quotesPage = try await quotes(
              tags: tags,
              authors: authors,
              sortBy: sortBy,
              limit: pageSize,
              page: currentPage
            )
            
            for quote in quotesPage.results {
              continuation.yield(quote)
            }
            
            hasMore = hasMorePages(quotesPage)
            currentPage += 1
          } catch {
            continuation.finish(throwing: error)
            return
          }
        }
        
        continuation.finish()
      }
    }
  }
}
