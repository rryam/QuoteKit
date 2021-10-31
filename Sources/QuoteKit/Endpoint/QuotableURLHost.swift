//
//  QuotableURLHost.swift
//  QuotableURLHost
//
//  Created by Rudrank Riyam on 29/08/21.
//

import Foundation

/// Learnt this way of creating a URLHost from this article - https://www.swiftbysundell.com/articles/testing-networking-logic-in-swift/

struct QuotableURLHost: RawRepresentable {
    var rawValue: String
}

extension QuotableURLHost {
    static var staging: Self {
        QuotableURLHost(rawValue: "staging.quotable.io")
    }
    
    static var images: Self {
        QuotableURLHost(rawValue: "images.quotable.dev")
    }
    
    static var production: Self {
        QuotableURLHost(rawValue: "api.quotable.io")
    }
    
    static var `default`: Self {
#if DEBUG
        return staging
#else
        return production
#endif
    }
}
