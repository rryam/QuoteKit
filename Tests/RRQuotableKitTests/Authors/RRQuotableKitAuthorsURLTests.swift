//
//  RRQuotableKitAuthorsURLTests.swift
//  RRQuotableKitAuthorsURLTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import RRQuotableKit

final class RRQuotableKitAuthorsURLTests: XCTestCase {
    let host = QuotableURLHost.production
    
    func testURLForParticularID() {
        let url = QuotableEndpoint(.author("XYxYtSeixS-o")).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors/XYxYtSeixS-o"))
    }
    
    func testURLForAuthors() {
        let url = QuotableEndpoint(.authors).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors"))
    }
    
    func testURLForSpecificAuthor() {
        let url = QuotableEndpoint(.authors, queryItems: [.slugs(["aesop"])]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?slug=aesop"))
    }
    
    func testURLForManyAuthors() {
        let url = QuotableEndpoint(.authors, queryItems: [.slugs(["aesop", "theophrastus"])]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?slug=aesop|theophrastus"))
    }
    
    func testURLWithSortParameter() {
        let url = QuotableEndpoint(.authors, queryItems: [.sortBy(.dateModified)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?sortBy=dateModified"))
    }
    
    func testURLWithOrderParameter() {
        let url = QuotableEndpoint(.authors, queryItems: [.order(.descending)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?order=desc"))
    }
    
    func testURLWithSortAndOrderParameter() {
        let url = QuotableEndpoint(.authors, queryItems: [.sortBy(.dateAdded), .order(.ascending)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?sortBy=dateAdded&order=asc"))
    }
    
    func testURLWithLimitParameter() {
        let url = QuotableEndpoint(.authors, queryItems: [.limit(50)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?limit=50"))
    }
    
    func testURLWithPagesParameter() {
        let url = QuotableEndpoint(.authors, queryItems: [.page(2)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?page=2"))
    }
    
    func testURLWithLimitAndPagesParameter() {
        let url = QuotableEndpoint(.authors, queryItems: [.limit(50), .page(2)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "authors?limit=50&page=2"))
    }
    
    func testURLforSearchAuthors() {
        let url = QuotableEndpoint(.searchAuthors, queryItems: [.search("kalam")]).url
        try XCTAssertEqual(url, host.expectedURL(with: "search/authors?query=kalam"))
    }
}
