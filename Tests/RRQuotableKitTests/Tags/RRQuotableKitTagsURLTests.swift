//
//  RRQuotableKitTagsURLTests.swift
//  RRQuotableKitTagsURLTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import RRQuotableKit

final class RRQuotableKitTagsURLTests: XCTestCase {
    let host = QuotableURLHost.production
    
    func testURLWithSortParameter() {
        let url = QuotableEndpoint(.tags, queryItems: [.sortBy(.dateModified)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "tags?sortBy=dateModified"))
    }
    
    func testURLWithOrderParameter() {
        let url = QuotableEndpoint(.tags, queryItems: [.order(.descending)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "tags?order=desc"))
    }
    
    func testURLWithSortAndOrderParameter() {
        let url = QuotableEndpoint(.tags, queryItems: [.sortBy(.dateAdded), .order(.ascending)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "tags?sortBy=dateAdded&order=asc"))
    }
}
