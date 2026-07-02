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
    case apiID = "_id"
    case tags, content, author, authorSlug, length, dateAdded, dateModified
    case name, slug
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try container.decodeIfPresent(String.self, forKey: .id)
      ?? container.decode(String.self, forKey: .apiID)
    content = try container.decode(String.self, forKey: .content)
    length = try container.decodeIfPresent(Int.self, forKey: .length) ?? content.count

    if let authorName = try? container.decode(String.self, forKey: .author) {
      author = authorName
      authorSlug = try container.decodeIfPresent(String.self, forKey: .authorSlug) ?? ""
    } else {
      let authorContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
      author = try authorContainer.decode(String.self, forKey: .name)
      authorSlug = try authorContainer.decode(String.self, forKey: .slug)
    }

    if let tagNames = try? container.decode([String].self, forKey: .tags) {
      tags = tagNames
    } else {
      var tagNames: [String] = []
      var tagsContainer = try container.nestedUnkeyedContainer(forKey: .tags)
      while !tagsContainer.isAtEnd {
        let tagContainer = try tagsContainer.nestedContainer(keyedBy: CodingKeys.self)
        let tagName = try tagContainer.decode(String.self, forKey: .name)
        tagNames.append(tagName.lowercased().replacingOccurrences(of: " ", with: "-"))
      }
      tags = tagNames
    }

    dateAdded = (try? container.decode(String.self, forKey: .dateAdded)) ?? ""
    dateModified = (try? container.decode(String.self, forKey: .dateModified)) ?? ""
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(tags, forKey: .tags)
    try container.encode(content, forKey: .content)
    try container.encode(author, forKey: .author)
    try container.encode(authorSlug, forKey: .authorSlug)
    try container.encode(length, forKey: .length)
    try container.encode(dateAdded, forKey: .dateAdded)
    try container.encode(dateModified, forKey: .dateModified)
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
