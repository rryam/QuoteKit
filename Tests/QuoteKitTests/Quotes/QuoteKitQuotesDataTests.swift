//
//  QuoteKitQuotesDataTests.swift
//  QuoteKitQuotesDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import QuoteKit

final class QuoteKitQuotesDataTests: XCTestCase {
    func testQuoteForParticularID() async throws {
        do {
            let quote = try await QuoteKit.quote(id: "2xpHvSOQMD")
            let unwrappedQuote = try XCTUnwrap(quote)
            
            XCTAssertEqual(unwrappedQuote.tags, [.famousQuotes, .inspirational])
            XCTAssertEqual(unwrappedQuote.id, "2xpHvSOQMD")
            XCTAssertEqual(unwrappedQuote.author, "Helmut Schmidt")
            XCTAssertEqual(unwrappedQuote.content, "The biggest room in the world is room for improvement.")
            XCTAssertEqual(unwrappedQuote.authorSlug, "helmut-schmidt")
            XCTAssertEqual(unwrappedQuote.length, 54)
            XCTAssertEqual(unwrappedQuote.dateAdded, "2021-06-18")
            XCTAssertEqual(unwrappedQuote.dateModified, "2021-06-18")
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
}
