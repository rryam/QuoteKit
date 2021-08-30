//
//  Author.swift
//  Author
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

struct Author: Codable, Identifiable {
    let link: String
    let bio: String
    let description: String
    let id: String
    let name: String
    let quoteCount: Int
    let slug: String
    let dateAdded: String
    let dateModified: String
    let quotes: [Quote]?
    
    enum CodingKeys: String, CodingKey {
        case link, bio, description
        case id = "_id"
        case name, quoteCount, slug
        case dateAdded, dateModified
        case quotes
    }
}

extension Author: Equatable {
    static func ==(lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
    }
}
