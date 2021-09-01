//
//  Quote.swift
//  Quote
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct Quote: Decodable, Identifiable {
    public var id: String
    public var tags: [TagType]
    public var content: String
    public var author: String
    public var authorSlug: String
    public var length: Int
    public var dateAdded: String
    public var dateModified: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags, content, author, authorSlug, length, dateAdded, dateModified
    }
}
