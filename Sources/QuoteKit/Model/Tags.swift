//
//  Tags.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

/// A typealias for an array of `Tag` instances.
public typealias Tags = [Tag]

/// A struct that represents a tag.
///
/// Use this struct to model a tag that can be associated with a quote.
/// The struct conforms to the `Identifiable` and `Hashable` protocols, which
/// means it has an `id` property and can be used in a `Set` or a `Dictionary`.
///
/// Example usage:
///
/// ```
/// let tag = Tag(id: "1", name: "technology", dateAdded: "2022-04-15T12:00:00Z", dateModified: "2022-04-15T12:00:00Z", quoteCount: 5)
/// ```
public struct Tag: Identifiable, Hashable {

  /// The unique identifier for the tag.
  public var id: String

  /// The name of the tag.
  public var name: String

  /// The date the tag was added, in ISO 8601 format.
  public var dateAdded: String

  /// The date the tag was last modified, in ISO 8601 format.
  public var dateModified: String

  /// The number of quotes associated with the tag.
  public var quoteCount: Int

  /// The capitalized name of the tag, with hyphens replaced by spaces.
  public var capitalisedName: String {
    name.capitalized.replacingOccurrences(of: "-", with: " ")
  }

  /// Initializes a new `Tag` instance with the given properties.
  ///
  /// - Parameters:
  ///   - id: The unique identifier for the tag.
  ///   - name: The name of the tag.
  ///   - dateAdded: The date the tag was added, in ISO 8601 format.
  ///   - dateModified: The date the tag was last modified, in ISO 8601 format.
  ///   - quoteCount: The number of quotes associated with the tag.
  public init(id: String, name: String, dateAdded: String, dateModified: String, quoteCount: Int) {
    self.id = id
    self.name = name
    self.dateAdded = dateAdded
    self.dateModified = dateModified
    self.quoteCount = quoteCount
  }
}

extension Tag: Decodable {
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case name, dateAdded, dateModified
    case quoteCount
  }
}
