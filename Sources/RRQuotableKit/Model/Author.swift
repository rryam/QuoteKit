//
//  Author.swift
//  Author
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct Author: Decodable, Identifiable {
    public var id: String
    public var link: String
    public var bio: String
    public var description: String
    public var name: String
    public var quoteCount: Int
    public var slug: String
    public var dateAdded: String
    public var dateModified: String
    public var quotes: [Quote]?
    
    enum CodingKeys: String, CodingKey {
        case link, bio, description
        case id = "_id"
        case name, quoteCount, slug
        case dateAdded, dateModified
        case quotes
    }
}

extension Author: Equatable {
    public static func ==(lhs: Author, rhs: Author) -> Bool {
        lhs.id == rhs.id
    }
}
