//
//  URLQueryItem.swift
//  URLQueryItem
//
//  Created by Rudrank Riyam on 29/08/21.
//

import Foundation

enum QuotesSortType: String {
    case dateAdded
    case dateModified
    case author
    case content
}

enum QuotableListOrder: String {
    case ascending = "asc"
    case descending = "desc"
}

enum AuthorsAndTagsSortType: String {
    case dateAdded
    case dateModified
    case name
    case quoteCount
}

enum URLQueryItemListType {
    case all
    case either
}

extension URLQueryItem {
    static func maxLength(_ length: Int) -> Self {
        URLQueryItem(name: "maxLength", value: String(length))
    }
    
    static func minLength(_ length: Int) -> Self {
        URLQueryItem(name: "minLength", value: String(length))
    }
    
    static func tags(_ tags: [TagType], _ type: URLQueryItemListType = .all) -> Self {
        var tagsValue = ""
        
        switch type {
            case .all:
                tagsValue = tags.map { $0.name }.joined(separator: ",")
            case .either:
                tagsValue = tags.map { $0.name }.joined(separator: "|")
        }
        
        return URLQueryItem(name: "tags", value: tagsValue)
    }
    
    static func authors(_ authors: [String]) -> Self {
        let authorsValue = authors.joined(separator: "|")
        return URLQueryItem(name: "author", value: authorsValue)
    }
    
    static func slugs(_ slugs: [String]) -> Self {
        let slugsValue = slugs.joined(separator: "|")
        return URLQueryItem(name: "slug", value: slugsValue)
    }
    
    static func limit(_ limit: Int) -> Self {
        if limit < 1 || limit > 150 {
            return URLQueryItem(name: "limit", value: String(20))
        } else {
            return URLQueryItem(name: "limit", value: String(limit))
        }
    }
    
    static func page(_ page: Int) -> Self {
        if page < 1 {
            return URLQueryItem(name: "page", value: String(1))
        } else {
            return URLQueryItem(name: "page", value: String(page))
        }
    }
    
    static func sortQuotesBy(_ sortType: QuotesSortType) -> Self {
        URLQueryItem(name: "sortBy", value: sortType.rawValue)
    }
    
    static func sortBy(_ sortType: AuthorsAndTagsSortType) -> Self {
        URLQueryItem(name: "sortBy", value: sortType.rawValue)
    }
    
    static func order(_ order: QuotableListOrder) -> Self {
        URLQueryItem(name: "order", value: order.rawValue)
    }
}
