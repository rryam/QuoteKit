//
//  RRQuotableKitQuotesURLTests.swift
//  RRQuotableKitQuotesURLTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import RRQuotableKit

final class RRQuotableKitQuotesURLTests: XCTestCase {
    let host = QuotableURLHost.production
    
    func testURLForParticularID() {
        let url = QuotableEndpoint(.quote("_XB2MKPzW7dA")).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes/_XB2MKPzW7dA"))
    }
    
    func testURLForQuotes() {
        let url = QuotableEndpoint(.quotes).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes"))
    }
    
    func testURLWithEitherOfTheProvidedTagsParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.tags([.love, .happiness], .either)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?tags=love|happiness"))
    }
    
    func testURLWithAllOfTheProvidedTagsParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.tags([.technology, .famousQuotes], .all)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?tags=technology,famous-quotes"))
    }
    
    func testURLForSpecificAuthor() {
        let url = QuotableEndpoint(.quotes, queryItems: [.authors(["albert-einstein"])]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?author=albert-einstein"))
    }
    
    func testURLForManyAuthors() {
        let url = QuotableEndpoint(.quotes, queryItems: [.authors(["albert-einstein", "ed-cunningham"])]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?author=albert-einstein|ed-cunningham"))
    }
    
    func testURLWithSortParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.sortQuotesBy(.dateAdded)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?sortBy=dateAdded"))
    }
    
    func testURLWithOrderParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.order(.descending)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?order=desc"))
    }
    
    func testURLWithSortAndOrderParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.sortQuotesBy(.content), .order(.ascending)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?sortBy=content&order=asc"))
    }
    
    func testURLWithLimitParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.limit(50)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?limit=50"))
    }
    
    func testURLWithPagesParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.page(2)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?page=2"))
    }
    
    func testURLWithLimitAndPagesParameter() {
        let url = QuotableEndpoint(.quotes, queryItems: [.limit(50), .page(2)]).url
        try XCTAssertEqual(url, host.expectedURL(with: "quotes?limit=50&page=2"))
    }
}
