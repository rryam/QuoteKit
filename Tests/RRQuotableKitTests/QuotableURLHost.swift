//
//  QuotableURLHost.swift
//  QuotableURLHost
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import RRQuotableKit

extension QuotableURLHost {
    func expectedURL(with path: String) throws -> URL {
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let url = URL(string: "https://" + rawValue + "/" + encodedPath)
        return try XCTUnwrap(url)
    }
}
