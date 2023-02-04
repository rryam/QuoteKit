//
//  Tags.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public typealias Tags = [Tag]

public struct Tag: Identifiable, Hashable {
  public var id: String
  public var name: String
  public var dateAdded: String
  public var dateModified: String
  public var quoteCount: Int

  public var capitalisedName: String {
    name.capitalized.replacingOccurrences(of: "-", with: " ")
  }

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
