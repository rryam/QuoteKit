//
//  QuotesDataTests.swift
//  QuotesDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import QuoteKit

final class QuotesDataTests: XCTestCase {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testQuoteForParticularIDAsync() async throws {
        do {
            let quote = try await QuoteKit.quote(id: "2xpHvSOQMD")
            let unwrappedQuote = try XCTUnwrap(quote)
            
            XCTAssertEqual(unwrappedQuote.tags, ["famous-quotes", "inspirational"])
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
    
    func testQuoteForParticularID() throws {
        let expectation = XCTestExpectation(description: #function)
        
        var givenQuote: Quote?
        
        QuoteKit.quote(id: "2xpHvSOQMD") { result in
            switch result {
                case .success(let quote):
                    givenQuote = quote
                    
                    expectation.fulfill()
                    
                case .failure(let error):
                    XCTFail("Expected quote, but failed \(error).")
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        let unwrappedQuote = try XCTUnwrap(givenQuote)
        
        XCTAssertEqual(unwrappedQuote.tags, ["famous-quotes", "inspirational"])
        XCTAssertEqual(unwrappedQuote.id, "2xpHvSOQMD")
        XCTAssertEqual(unwrappedQuote.author, "Helmut Schmidt")
        XCTAssertEqual(unwrappedQuote.content, "The biggest room in the world is room for improvement.")
        XCTAssertEqual(unwrappedQuote.authorSlug, "helmut-schmidt")
        XCTAssertEqual(unwrappedQuote.length, 54)
        XCTAssertEqual(unwrappedQuote.dateAdded, "2021-06-18")
        XCTAssertEqual(unwrappedQuote.dateModified, "2021-06-18")
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testQuotesReturnsManyQuotesAsync() async throws {
        do {
            let quotes = try await QuoteKit.quotes()
            let unwrappedQuotes = try XCTUnwrap(quotes)
            
            XCTAssertGreaterThan(unwrappedQuotes.count, 1)
        } catch {
            XCTFail("Expected quotes, but failed \(error).")
        }
    }
    
    func testQuotesReturnsManyQuotes() throws {
        let expectation = XCTestExpectation(description: #function)
        
        var givenQuotes: Quotes?
        
        QuoteKit.quotes { result in
            switch result {
                case .success(let quotes):
                    givenQuotes = quotes
                    
                    expectation.fulfill()
                    
                case .failure(let error):
                    XCTFail("Expected quotes, but failed \(error).")
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        let unwrappedQuotes = try XCTUnwrap(givenQuotes)
        
        XCTAssertGreaterThan(unwrappedQuotes.count, 1)
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testQuotesSearchForParticularQueryAsync() async throws {
        do {
            let quotes = try await QuoteKit.searchQuotes(for: "biggest room")
            let unwrappedQuote = try XCTUnwrap(quotes?.results.first)
            
            XCTAssertEqual(unwrappedQuote.tags, ["famous-quotes", "inspirational"])
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
    
    func testQuotesSearchForParticularQuery() throws {
        let expectation = XCTestExpectation(description: #function)
        
        var givenQuotes: Quotes?
        
        QuoteKit.searchQuotes(for: "biggest room") { result in
            switch result {
                case .success(let quotes):
                    givenQuotes = quotes
                    
                    expectation.fulfill()
                    
                case .failure(let error):
                    XCTFail("Expected quotes, but failed \(error).")
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        let unwrappedQuote = try XCTUnwrap(givenQuotes?.results.first)
        
        XCTAssertEqual(unwrappedQuote.tags, ["famous-quotes", "inspirational"])
        XCTAssertEqual(unwrappedQuote.id, "2xpHvSOQMD")
        XCTAssertEqual(unwrappedQuote.author, "Helmut Schmidt")
        XCTAssertEqual(unwrappedQuote.content, "The biggest room in the world is room for improvement.")
        XCTAssertEqual(unwrappedQuote.authorSlug, "helmut-schmidt")
        XCTAssertEqual(unwrappedQuote.length, 54)
        XCTAssertEqual(unwrappedQuote.dateAdded, "2021-06-18")
        XCTAssertEqual(unwrappedQuote.dateModified, "2021-06-18")
    }
}
