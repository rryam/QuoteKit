//
//  File.swift
//  
//
//  Created by Rudrank Riyam on 03/10/21.
//

import Foundation

public extension QuoteKit {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static func tags(sortBy: AuthorsAndTagsSortType? = nil,
                     order: QuotableListOrder? = nil) async throws -> Tags? {
        
        let queryItems = tagsParameters(sortBy: sortBy, order: order)
        
        return try await execute(with: QuotableEndpoint(.tags, queryItems: queryItems))
    }
    
    @available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
    static func tags(sortBy: AuthorsAndTagsSortType? = nil,
                     order: QuotableListOrder? = nil,
                     completion: @escaping (Result<Tags?, Error>) -> ()) {
        
        let queryItems = tagsParameters(sortBy: sortBy, order: order)
        
        return execute(with: QuotableEndpoint(.tags, queryItems: queryItems), completion: completion)
    }
    
    @available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *)
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
