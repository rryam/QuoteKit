//
//  QuotableItems.swift
//  QuotableItems
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

struct QuotableItems<Item: Codable>: Codable {
    let count: Int
    let totalCount: Int
    let page: Int
    let totalPages: Int
    let lastItemIndex: Int?
    var results: [Item]
}
