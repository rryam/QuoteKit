//
//  AuthorAPIs.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 03/10/21.
//

import Foundation

public extension QuoteKit {
  /// Generates a URL for an author's profile image.
  /// - Parameters:
  ///   - slug: The author's slug identifier.
  ///   - size: The desired image size in pixels. Defaults to 700.
  /// - Returns: A URL pointing to the author's profile image.
  static func authorImage(with slug: String, size: Int = 700) -> URL {
    QuotableEndpoint(.authorProfile(size, slug), host: .images).url
  }

  /// Fetches a single author by their unique identifier.
  /// - Parameter id: The unique identifier of the author.
  /// - Returns: An `Author` object containing the author's details.
  /// - Throws: An error if the network request fails or the author is not found.
  static func author(id: String) async throws -> Author {
    try await execute(with: QuotableEndpoint(.author(id)))
  }

  /// Fetches a paginated list of authors with optional filtering and sorting.
  /// - Parameters:
  ///   - slugs: Array of author slugs to filter by (optional).
  ///   - sortBy: Sort authors by a specific field (optional).
  ///   - order: Sort order - `.ascending` or `.descending` (optional).
  ///   - limit: Number of authors per page (1-150). Defaults to 20.
  ///   - page: Page number to retrieve. Defaults to 1.
  /// - Returns: An `Authors` collection containing the paginated results.
  /// - Throws: An error if the network request fails.
  static func authors(slugs: [String]? = nil,
                      sortBy: AuthorsAndTagsSortType? = nil,
                      order: QuotableListOrder? = nil,
                      limit: Int = 20,
                      page: Int = 1) async throws -> Authors {

    let queryItems = authorsParameters(slugs: slugs, sortBy: sortBy, order: order, limit: limit, page: page)

    return try await execute(with: QuotableEndpoint(.authors, queryItems: queryItems))
  }

  private static func authorsParameters(slugs: [String]? = nil,
                                        sortBy: AuthorsAndTagsSortType? = nil,
                                        order: QuotableListOrder? = nil,
                                        limit: Int = 20,
                                        page: Int = 1) -> [URLQueryItem] {

    var queryItems: [URLQueryItem] = []

    queryItems.append(.limit(limit))
    queryItems.append(.page(page))

    if let slugs = slugs {
      queryItems.append(.slugs(slugs))
    }

    if let sortBy = sortBy {
      queryItems.append(.sortBy(sortBy))
    }

    if let order = order {
      queryItems.append(.order(order))
    }

    return queryItems
  }
}

// MARK: - Async Sequences

public extension QuoteKit {
  /// Creates an async sequence that automatically fetches all pages of authors.
  /// - Parameters:
  ///   - sortBy: Sort authors by a specific field (optional).
  ///   - pageSize: Number of items per page. Defaults to 100.
  /// - Returns: An async sequence of `Author` objects.
  @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
  static func allAuthors(
    sortBy: AuthorsAndTagsSortType? = nil,
    pageSize: Int = 100
  ) -> AsyncThrowingStream<Author, Error> {
    AsyncThrowingStream { continuation in
      Task { @Sendable in
        var currentPage = 1
        var hasMore = true
        
        while hasMore {
          do {
            let authorsPage = try await authors(
              sortBy: sortBy,
              limit: pageSize,
              page: currentPage
            )
            
            for author in authorsPage.results {
              continuation.yield(author)
            }
            
            hasMore = hasMorePages(authorsPage)
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
