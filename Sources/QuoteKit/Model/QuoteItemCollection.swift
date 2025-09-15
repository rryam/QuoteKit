//
//  QuoteItemCollection.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

/// This struct represents a collection of items that can be decoded from JSON data.
///
/// Use this struct to model a collection of items that can be retrieved from an API response.
/// The struct conforms to the `Decodable` protocol, which means it can be initialized from
/// JSON data.
///
/// Example usage:
///
/// ```swift
/// let json = """
/// {
///     "count": 5,
///     "total_count": 10,
///     "page": 1,
///     "total_pages": 2,
///     "last_item_index": 4,
///     "results": [
///         {"id": 1, "name": "Item 1"},
///         {"id": 2, "name": "Item 2"},
///         {"id": 3, "name": "Item 3"},
///         {"id": 4, "name": "Item 4"},
///         {"id": 5, "name": "Item 5"}
///     ]
/// }
/// """.data(using: .utf8)!
///
/// struct Item: Decodable {
///     let id: Int
///     let name: String
/// }
///
/// let collection = try JSONDecoder().decode(QuoteItemCollection<Item>.self, from: json)
/// print(collection.totalCount) // Prints "10"
/// print(collection.results.count) // Prints "5"
/// ```

/// Response structure from the Quotable API
private struct APIResponse<Item: Decodable>: Decodable {
  let data: [Item]
  let metadata: Metadata

  struct Metadata: Decodable {
    let total: Int
    let page: Int
    let lastPage: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
  }
}

public struct QuoteItemCollection<Item: Decodable & Sendable>: Decodable, Sendable {

  /// The number of items in the collection.
  public var count: Int

  /// The total number of items available.
  public var totalCount: Int

  /// The current page number.
  public var page: Int

  /// The total number of pages.
  public var totalPages: Int

  /// The index of the last item in the collection, if known.
  public var lastItemIndex: Int?

  /// The items in the collection.
  public var results: [Item]

  /// Initializes a new `QuoteItemCollection` instance with the given properties.
  ///
  /// - Parameters:
  ///   - count: The number of items in the collection.
  ///   - totalCount: The total number of items available.
  ///   - page: The current page number.
  ///   - totalPages: The total number of pages.
  ///   - lastItemIndex: The index of the last item in the collection, if known.
  ///   - results: The items in the collection.
  public init(count: Int, totalCount: Int, page: Int, totalPages: Int, lastItemIndex: Int?, results: [Item]) {
    self.count = count
    self.totalCount = totalCount
    self.page = page
    self.totalPages = totalPages
    self.lastItemIndex = lastItemIndex
    self.results = results
  }

  // MARK: - Decodable

  public init(from decoder: Decoder) throws {
    let response = try APIResponse<Item>(from: decoder)

    self.count = response.data.count
    self.totalCount = response.metadata.total
    self.page = response.metadata.page + 1 // Convert 0-based to 1-based
    self.totalPages = response.metadata.lastPage + 1 // Convert 0-based to 1-based
    self.lastItemIndex = nil // Not provided by API
    self.results = response.data
  }
}
