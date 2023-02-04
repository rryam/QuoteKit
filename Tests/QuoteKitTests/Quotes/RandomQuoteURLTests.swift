//
//  RandomQuoteURLTests.swift
//  RandomQuoteURLTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

@testable import QuoteKit
import XCTest

final class RandomQuoteURLTests: XCTestCase {
  let host = QuotableURLHost.production

  func testURLForRandomQuote() {
    let url = QuotableEndpoint(.randomQuote).url
    try XCTAssertEqual(url, host.expectedURL(with: "random"))
  }

  func testURLForMinimumLengthQuote() {
    let url = QuotableEndpoint(.randomQuote, queryItems: [.minLength(10)]).url
    try XCTAssertEqual(url, host.expectedURL(with: "random?minLength=10"))
  }

  func testURLForMaximumLengthQuote() {
    let url = QuotableEndpoint(.randomQuote, queryItems: [.maxLength(100)]).url
    try XCTAssertEqual(url, host.expectedURL(with: "random?maxLength=100"))
  }

  func testURLForMinimumAndMaximumLengthQuote() {
    let url = QuotableEndpoint(.randomQuote, queryItems: [.minLength(10), .maxLength(100)]).url
    try XCTAssertEqual(url, host.expectedURL(with: "random?minLength=10&maxLength=100"))
  }

  func testURLWithEitherOfTheProvidedTagsParameter() {
    let url = QuotableEndpoint(.randomQuote, queryItems: [.tags(["love", "happiness"], .either)]).url
    try XCTAssertEqual(url, host.expectedURL(with: "random?tags=love|happiness"))
  }

  func testURLWithAllOfTheProvidedTagsParameter() {
    let url = QuotableEndpoint(.randomQuote, queryItems: [.tags(["technology", "famous-quotes"], .all)]).url
    try XCTAssertEqual(url, host.expectedURL(with: "random?tags=technology,famous-quotes"))
  }

  func testURLForSpecificAuthor() {
    let url = QuotableEndpoint(.randomQuote, queryItems: [.authors(["albert-einstein"])]).url
    try XCTAssertEqual(url, host.expectedURL(with: "random?author=albert-einstein"))
  }

  func testURLForManyAuthors() {
    let url = QuotableEndpoint(.randomQuote, queryItems: [.authors(["albert-einstein", "ed-cunningham"])]).url
    try XCTAssertEqual(url, host.expectedURL(with: "random?author=albert-einstein|ed-cunningham"))
  }
}
