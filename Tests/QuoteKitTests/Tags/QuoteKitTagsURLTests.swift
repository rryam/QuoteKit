//
//  QuoteKitTagsURLTests.swift
//  QuoteKitTagsURLTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest

@testable import QuoteKit

final class QuoteKitTagsURLTests: XCTestCase {
  private let host = QuotableURLHost.default

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
