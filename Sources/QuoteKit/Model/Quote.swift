//
//  Quote.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct Quote: Identifiable, Equatable {
  public var id: String
  public var tags: [String]
  public var content: String
  public var author: String
  public var authorSlug: String
  public var length: Int
  public var dateAdded: String
  public var dateModified: String
  
  init(id: String, tags: [String], content: String, author: String, authorSlug: String, length: Int, dateAdded: String, dateModified: String) {
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

extension Quote: Decodable {
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case tags, content, author, authorSlug, length, dateAdded, dateModified
  }
}

extension Quote {
  public static var preview = Quote(id: UUID().uuidString, tags: ["wisdom"], content: "Financial freedom is all about doing what you really want and not worry about money at all.", author: "Rudrank Riyam", authorSlug: "rudrank-riyam", length: 61, dateAdded: String(describing: Date()), dateModified: String(describing: Date()))
}
