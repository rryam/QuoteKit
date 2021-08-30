//
//  Quote.swift
//  Quote
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

struct Quote: Codable, Identifiable {
    let id: String
    let tags: [TagType]
    let content: String
    let author: String
    let authorSlug: String
    let length: Int
    let dateAdded: String
    let dateModified: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags, content, author, authorSlug, length, dateAdded, dateModified
    }
}
