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
    case id = "_id"
    case tags, content, author, authorSlug, length, dateAdded, dateModified
  }
}

/// Wrapper for backup API response format
internal struct BackupQuoteResponse: Decodable {
  let quote: BackupQuote
}

/// Quote structure from backup API
internal struct BackupQuote: Decodable {
  let id: String
  let content: String
  let tags: [BackupTag]
  let author: BackupAuthor
}

internal struct BackupTag: Decodable {
  let name: String
}

internal struct BackupAuthor: Decodable {
  let name: String
  let slug: String
}

extension Quote {
  /// Initialize from backup API response
  internal init(from backupQuote: BackupQuote) {
    self.id = backupQuote.id
    self.content = backupQuote.content
    self.author = backupQuote.author.name
    self.authorSlug = backupQuote.author.slug
    self.tags = backupQuote.tags.map { $0.name }
    self.length = backupQuote.content.count
    self.dateAdded = ""
    self.dateModified = ""
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
