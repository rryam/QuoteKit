//
//  File.swift
//  
//
//  Created by Rudrank Riyam on 03/10/21.
//

import Foundation

public extension QuoteKit {
    static func tags(sortBy: AuthorsAndTagsSortType? = nil,
                     order: QuotableListOrder? = nil) async throws -> Tags {
        
        let queryItems = tagsParameters(sortBy: sortBy, order: order)
        
        return try await execute(with: QuotableEndpoint(.tags, queryItems: queryItems))
    }
    
    private static func tagsParameters(sortBy: AuthorsAndTagsSortType? = nil,
                                       order: QuotableListOrder? = nil) -> [URLQueryItem] {
        
        var queryItems: [URLQueryItem] = []
        
        if let sortBy = sortBy {
            queryItems.append(.sortBy(sortBy))
        }
        
        if let order = order {
            queryItems.append(.order(order))
        }
        
        return queryItems
    }
}
