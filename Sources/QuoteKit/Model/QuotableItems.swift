//
//  QuotableItems.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct QuotableItems<Item: Decodable>: Decodable {
  public var count: Int
  public var totalCount: Int
  public var page: Int
  public var totalPages: Int
  public var lastItemIndex: Int?
  public var results: [Item]
}
