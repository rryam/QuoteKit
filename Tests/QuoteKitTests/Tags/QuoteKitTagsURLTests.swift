//
//  QuoteKitTagsURLTests.swift
//  QuoteKitTagsURLTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

@testable import QuoteKit
import XCTest

final class QuoteKitTagsURLTests: XCTestCase {
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
