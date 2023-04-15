//
//  QuotesDataTests.swift
//  QuotesDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

@testable import QuoteKit
import XCTest

final class QuotesDataTests: XCTestCase {
  func testQuoteForParticularID() async throws {
    do {
      let quote = try await QuoteKit.quote(id: "2xpHvSOQMD")
      let unwrappedQuote = try XCTUnwrap(quote)

      XCTAssertEqual(unwrappedQuote.tags, ["Famous Quotes", "Inspirational"])
      XCTAssertEqual(unwrappedQuote.id, "2xpHvSOQMD")
      XCTAssertEqual(unwrappedQuote.author, "Helmut Schmidt")
      XCTAssertEqual(unwrappedQuote.content, "The biggest room in the world is room for improvement.")
      XCTAssertEqual(unwrappedQuote.authorSlug, "helmut-schmidt")
      XCTAssertEqual(unwrappedQuote.length, 54)
      XCTAssertEqual(unwrappedQuote.dateAdded, "2021-06-18")
      XCTAssertEqual(unwrappedQuote.dateModified, "2023-04-14")
    } catch {
      XCTFail("Expected quote, but failed \(error).")
    }
  }

  func testQuotesReturnsManyQuotes() async throws {
    do {
      let quotes = try await QuoteKit.quotes()
      let unwrappedQuotes = try XCTUnwrap(quotes)

      XCTAssertGreaterThan(unwrappedQuotes.count, 1)
    } catch {
      XCTFail("Expected quotes, but failed \(error).")
    }
  }

  func testQuotesSearchForParticularQuery() async throws {
    do {
      let quotes = try await QuoteKit.searchQuotes(for: "biggest room")
      let unwrappedQuote = try XCTUnwrap(quotes.results.first)

      XCTAssertEqual(unwrappedQuote.tags, ["Famous Quotes", "Inspirational"])
      XCTAssertEqual(unwrappedQuote.id, "2xpHvSOQMD")
      XCTAssertEqual(unwrappedQuote.author, "Helmut Schmidt")
      XCTAssertEqual(unwrappedQuote.content, "The biggest room in the world is room for improvement.")
      XCTAssertEqual(unwrappedQuote.authorSlug, "helmut-schmidt")
      XCTAssertEqual(unwrappedQuote.length, 54)
      XCTAssertEqual(unwrappedQuote.dateAdded, "2021-06-18")
      XCTAssertEqual(unwrappedQuote.dateModified, "2023-04-14")
    } catch {
      XCTFail("Expected quote, but failed \(error).")
    }
  }
}
