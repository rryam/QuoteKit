//
//  Tags.swift
//  Tags
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public typealias Tags = [Tag]

public struct Tag: Decodable, Identifiable {
    public var id: String
    public var name: String
    public var dateAdded: String
    public var dateModified: String
    public var v: Int
    public var quoteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, dateAdded, dateModified
        case v = "__v"
        case quoteCount
    }
}
