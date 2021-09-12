//
//  TagType.swift
//  TagType
//
//  Created by Rudrank Riyam on 10/09/21.
//

import Foundation

public enum TagType: String, Decodable {
    case business
    case civilRights = "civil-rights"
    case education
    case faith
    case famousQuotes = "famous-quotes"
    case friendship
    case future
    case film
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
            case .civilRights: return "Civil Rights"
            case .famousQuotes: return "Famous Quotes"
            default: return rawValue.capitalized
        }
    }
}
