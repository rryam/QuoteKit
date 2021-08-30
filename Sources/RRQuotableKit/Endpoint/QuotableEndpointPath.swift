//
//  QuotableEndpointPath.swift
//  QuotableEndpointPath
//
//  Created by Rudrank Riyam on 29/08/21.
//

import Foundation

enum QuotableEndpointPath: CustomStringConvertible {
    case quotes
    case randomQuote
    case authors
    case tags
    case quote(String)
    case author(String)
    case authorProfile(Int, String)
    
    var description: String {
        switch self {
            case .quotes: return "quotes"
            case .randomQuote: return "random"
            case .authors: return "authors"
            case .tags: return "tags"
            case .quote(let id): return "quotes/\(id)"
            case .author(let id): return "authors/\(id)"
            case .authorProfile(let size, let slug): return "profile/\(size)/\(slug).jpg"
        }
    }
}
