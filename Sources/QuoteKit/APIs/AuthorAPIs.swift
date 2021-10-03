//
//  File.swift
//  
//
//  Created by Rudrank Riyam on 03/10/21.
//

import Foundation

public extension QuoteKit {
    static func authorImage(with slug: String, size: Int = 700) -> URL {
        QuotableEndpoint(.authorProfile(size, slug), host: .images).url
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static func author(id: String) async throws -> Author? {
        try await execute(with: QuotableEndpoint(.author(id)))
    }
    
    static func author(id: String, completion: @escaping (Result<Author?, Error>) -> ()) {
        execute(with: QuotableEndpoint(.author(id)), completion: completion)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static func authors(slugs: [String]? = nil,
                        sortBy: AuthorsAndTagsSortType? = nil,
                        order: QuotableListOrder? = nil,
                        limit: Int = 20,
                        page: Int = 1) async throws -> Authors? {
        
        let queryItems = authorsParameters(slugs: slugs, sortBy: sortBy, order: order, limit: limit, page: page)
        
        return try await execute(with: QuotableEndpoint(.authors, queryItems: queryItems))
    }
    
    static func authors(slugs: [String]? = nil,
                        sortBy: AuthorsAndTagsSortType? = nil,
                        order: QuotableListOrder? = nil,
                        limit: Int = 20,
                        page: Int = 1,
                        completion: @escaping (Result<Authors?, Error>) -> ()) {
        
        let queryItems = authorsParameters(slugs: slugs, sortBy: sortBy, order: order, limit: limit, page: page)
        
        return execute(with: QuotableEndpoint(.authors, queryItems: queryItems), completion: completion)
    }
    
    private static func authorsParameters(slugs: [String]? = nil,
                                          sortBy: AuthorsAndTagsSortType? = nil,
                                          order: QuotableListOrder? = nil,
                                          limit: Int = 20,
                                          page: Int = 1) -> [URLQueryItem] {
        
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(.limit(limit))
        queryItems.append(.page(page))
        
        if let slugs = slugs {
            queryItems.append(.slugs(slugs))
        }
        
        if let sortBy = sortBy {
            queryItems.append(.sortBy(sortBy))
        }
        
        if let order = order {
            queryItems.append(.order(order))
        }
        
        return queryItems
    }
}
