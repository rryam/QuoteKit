import Foundation

public struct RRQuotableKit {
    static func execute<Model: Decodable>(with endpoint: QuotableEndpoint) async throws -> Model {
        let url = endpoint.url
        
        debugPrint("THE URL IS \(url)")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Model.self, from: data)
    }
}

// MARK: - QUOTES APIS
public extension RRQuotableKit {
    static func quote(id: String) async throws -> Quote? {
        try await execute(with: QuotableEndpoint(.quote(id)))
    }
    
    static func quotes(minLength: Int? = nil,
                       maxLength: Int? = nil,
                       tags: [TagType]? = nil,
                       authors: [String]? = nil,
                       sortBy: AuthorsAndTagsSortType? = nil,
                       order: QuotableListOrder? = nil,
                       limit: Int = 20,
                       page: Int = 1) async throws -> Quotes? {
        
        var queryItems: [URLQueryItem] = []

        queryItems.append(.limit(limit))
        queryItems.append(.page(page))
        
        if let minLength = minLength {
            queryItems.append(.minLength(minLength))
        }
        
        if let maxLength = maxLength {
            queryItems.append(.maxLength(maxLength))
        }
        
        if let tags = tags {
            queryItems.append(.tags(tags))
        }
        
        if let authors = authors {
            queryItems.append(.authors(authors))
        }
        
        if let sortBy = sortBy {
            queryItems.append(.sortBy(sortBy))
        }
        
        if let order = order {
            queryItems.append(.order(order))
        }
        
        return try await execute(with: QuotableEndpoint(.quotes, queryItems: queryItems))
    }
    
    static func quotes() async throws -> Quotes? {
        try await execute(with: QuotableEndpoint(.quotes))
    }
    
    static func randomQuote(minLength: Int? = nil,
                            maxLength: Int? = nil,
                            tags: [TagType]? = nil,
                            authors: [String]? = nil) async throws -> Quote? {
        
        var queryItems: [URLQueryItem] = []

        if let minLength = minLength {
            queryItems.append(.minLength(minLength))
        }
        
        if let maxLength = maxLength {
            queryItems.append(.maxLength(maxLength))
        }
        
        if let tags = tags {
            queryItems.append(.tags(tags))
        }
        
        if let authors = authors {
            queryItems.append(.authors(authors))
        }
        
        return try await execute(with: QuotableEndpoint(.randomQuote, queryItems: queryItems))
    }
}

// MARK: - AUTHORS APIS
public extension RRQuotableKit {
    static func authorProfile(size: Int = 700, slug: String) -> URL {
        QuotableEndpoint(.authorProfile(size, slug), host: .images).url
    }
    
    static func author(id: String) async throws -> Author? {
        try await execute(with: QuotableEndpoint(.author(id)))
    }
    
    static func authors(slugs: [String]? = nil,
                        sortBy: AuthorsAndTagsSortType? = nil,
                        order: QuotableListOrder? = nil,
                        limit: Int = 20,
                        page: Int = 1) async throws -> Authors? {
        
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
        
        return try await execute(with: QuotableEndpoint(.authors, queryItems: queryItems))
    }
}

// MARK: - TAGS APIS
public extension RRQuotableKit {
    static func tags(sortBy: AuthorsAndTagsSortType? = nil,
                     order: QuotableListOrder? = nil) async throws -> Tags? {
        
        var queryItems: [URLQueryItem] = []

        if let sortBy = sortBy {
            queryItems.append(.sortBy(sortBy))
        }
        
        if let order = order {
            queryItems.append(.order(order))
        }
        
        return try await execute(with: QuotableEndpoint(.tags, queryItems: queryItems))
    }
}

// MARK: - SEARCH APIS
public extension RRQuotableKit {
    static func searchQuotes(for query: String, limit: Int = 20, page: Int = 1) async throws -> Quotes? {
        try await search(path: .searchQuotes, query: query, limit: limit, page: page)
    }
  
    static func searchAuthors(for query: String, limit: Int = 20, page: Int = 1) async throws -> Authors? {
        try await search(path: .searchAuthors, query: query, limit: limit, page: page)
    }
    
    private static func search<Model: Decodable>(path: QuotableEndpointPath, query: String, limit: Int = 20, page: Int = 1) async throws -> Model {
        var queryItems: [URLQueryItem] = []
        
        queryItems.append(.search(query))
        queryItems.append(.limit(limit))
        queryItems.append(.page(page))
                        
        return try await execute(with: QuotableEndpoint(path, queryItems: queryItems))
    }
}
