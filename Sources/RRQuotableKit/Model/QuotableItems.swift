//
//  QuotableItems.swift
//  QuotableItems
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct QuotableItems<Item: Codable>: Codable {
    public var count: Int
    public var totalCount: Int
    public var page: Int
    public var totalPages: Int
    public var lastItemIndex: Int?
    public var results: [Item]
    
    public init(count: Int, totalCount: Int, page: Int, totalPages: Int, lastItemIndex: Int? = nil, results: [Item]) {
        self.count = count
        self.totalCount = totalCount
        self.page = page
        self.totalPages = totalPages
        self.lastItemIndex = lastItemIndex
        self.results = results
    }
}
