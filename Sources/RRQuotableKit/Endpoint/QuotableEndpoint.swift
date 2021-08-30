//
//  QuotableEndpoint.swift
//  QuotableEndpoint
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

struct QuotableEndpoint {
    var path: QuotableEndpointPath
    var queryItems: [URLQueryItem]?
    var host: QuotableURLHost
    
    init(_ path: QuotableEndpointPath, queryItems: [URLQueryItem]? = nil, host: QuotableURLHost = .production) {
        self.path = path
        self.queryItems = queryItems
        self.host = host
    }
}

extension QuotableEndpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.rawValue
        components.path = "/" + path.description
        
        if let queryItems = queryItems {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}
