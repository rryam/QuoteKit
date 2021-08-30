//
//  Tags.swift
//  Tags
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public typealias Tags = [Tag]

public enum TagType: String, Codable {
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
    
    public var name: String {
        switch self {
            case .famousQuotes: return "famous-quotes"
            default: return rawValue
        }
    }
}

public struct Tag: Codable, Identifiable {
    public var id: String
    public var name: String
    public var dateAdded: String
    public var dateModified: String
    public var v: Int
    public var quoteCount: Int
    
    public init(id: String, name: String, dateAdded: String, dateModified: String, v: Int, quoteCount: Int) {
        self.id = id
        self.name = name
        self.dateAdded = dateAdded
        self.dateModified = dateModified
        self.v = v
        self.quoteCount = quoteCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, dateAdded, dateModified
        case v = "__v"
        case quoteCount
    }
}
