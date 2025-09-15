//
//  Author.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct Author: Identifiable, Codable, Sendable {
  public var id: String
  public var link: String
  public var bio: String
  public var description: String
  public var name: String
  public var quoteCount: Int
  public var slug: String
  public var dateAdded: String
  public var dateModified: String
  public var quotes: [Quote]?

  public init(id: String, link: String, bio: String, description: String, name: String, quoteCount: Int, slug: String, dateAdded: String, dateModified: String, quotes: [Quote]? = nil) {
    self.id = id
    self.link = link
    self.bio = bio
    self.description = description
    self.name = name
    self.quoteCount = quoteCount
    self.slug = slug
    self.dateAdded = dateAdded
    self.dateModified = dateModified
    self.quotes = quotes
  }
}

extension Author {
  enum CodingKeys: String, CodingKey {
    case link, bio, description
    case id
    case name, quoteCount, slug, quotesCount
    case dateAdded, dateModified
    case quotes
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    slug = try container.decode(String.self, forKey: .slug)

    // Handle both quoteCount (original) and quotesCount (backup) field names
    if let quoteCount = try? container.decode(Int.self, forKey: .quoteCount) {
      self.quoteCount = quoteCount
    } else if let quotesCount = try? container.decode(Int.self, forKey: .quotesCount) {
      self.quoteCount = quotesCount
    } else {
      self.quoteCount = 0
    }

    // Optional fields with defaults
    bio = (try? container.decode(String.self, forKey: .bio)) ?? ""
    description = (try? container.decode(String.self, forKey: .description)) ?? ""
    link = (try? container.decode(String.self, forKey: .link)) ?? ""
    dateAdded = (try? container.decode(String.self, forKey: .dateAdded)) ?? ""
    dateModified = (try? container.decode(String.self, forKey: .dateModified)) ?? ""
    quotes = try? container.decode([Quote].self, forKey: .quotes)
  }
}

extension Author: Equatable {
  public static func ==(lhs: Author, rhs: Author) -> Bool {
    lhs.id == rhs.id
  }
}

extension Author: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
