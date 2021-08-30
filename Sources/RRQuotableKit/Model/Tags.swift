//
//  Tags.swift
//  Tags
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

typealias Tags = [Tag]

enum TagType: String, Codable {
    case business
    case education
    case faith
    case famousQuotes = "famous-quotes"
    case friendship
    case future
    case happiness
    case history
    case inspirational
    case life
    case literature
    case love
    case nature
    case politics
    case proverb
    case religion
    case science
    case success
    case technology
    case wisdom
    
    var name: String {
        switch self {
            case .famousQuotes: return "famous-quotes"
            default: return rawValue
        }
    }
}

struct Tag: Codable, Identifiable {
    let id: String
    let name: String
    let dateAdded: String
    let dateModified: String
    let v: Int
    let quoteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, dateAdded, dateModified
        case v = "__v"
        case quoteCount
    }
}
