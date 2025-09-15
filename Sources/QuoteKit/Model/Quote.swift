//
//  Quote.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct Quote: Identifiable, Equatable, Codable, Sendable {
  public var id: String
  public var tags: [String]
  public var content: String
  public var author: String
  public var authorSlug: String
  public var length: Int
  public var dateAdded: String
  public var dateModified: String

  public init(
    id: String, tags: [String], content: String, author: String, authorSlug: String, length: Int,
    dateAdded: String, dateModified: String
  ) {
    self.id = id
    self.tags = tags
    self.content = content
    self.author = author
    self.authorSlug = authorSlug
    self.length = length
    self.dateAdded = dateAdded
    self.dateModified = dateModified
  }
}

extension Quote {
  enum CodingKeys: String, CodingKey {
    case id
    case tags, content, author, authorSlug, length, dateAdded, dateModified
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try container.decode(String.self, forKey: .id)
    content = try container.decode(String.self, forKey: .content)
    length = content.count

    // Handle nested author object
    let authorContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
    author = try authorContainer.decode(String.self, forKey: .name)
    authorSlug = try authorContainer.decode(String.self, forKey: .slug)

    // Handle tags array with nested name property
    var tagsArray: [String] = []
    var tagsContainer = try container.nestedUnkeyedContainer(forKey: .tags)
    while !tagsContainer.isAtEnd {
      let tagContainer = try tagsContainer.nestedContainer(keyedBy: CodingKeys.self)
      let tagName = try tagContainer.decode(String.self, forKey: .name)
      tagsArray.append(tagName)
    }
    tags = tagsArray

    // Optional fields with defaults
    dateAdded = (try? container.decode(String.self, forKey: .dateAdded)) ?? ""
    dateModified = (try? container.decode(String.self, forKey: .dateModified)) ?? ""
  }
}

extension Quote {
  public static let preview = Quote(
    id: UUID().uuidString, tags: ["wisdom"],
    content:
      "Financial freedom is all about doing what you really want and not worry about money at all.",
    author: "Rudrank Riyam", authorSlug: "rudrank-riyam", length: 61,
    dateAdded: String(describing: Date()), dateModified: String(describing: Date()))
}
