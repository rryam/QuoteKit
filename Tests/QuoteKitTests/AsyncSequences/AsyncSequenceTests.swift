//
//  AsyncSequenceTests.swift
//  QuoteKitTests
//
//  Tests for async sequence functionality focusing on logic rather than integration.
//

import Testing

@testable import QuoteKit

@Suite("Async Sequence Logic Tests")
struct AsyncSequenceTests {
    // MARK: - Type and Availability Tests

    @Test("allQuotes returns AsyncThrowingStream type")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesReturnType() {
        let sequence = QuoteKit.allQuotes()

        // Verify it's the expected type
        #expect(type(of: sequence) == AsyncThrowingStream<Quote, Error>.self)
    }

    @Test("allAuthors returns AsyncThrowingStream type")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsReturnType() {
        let sequence = QuoteKit.allAuthors()

        // Verify it's the expected type
        #expect(type(of: sequence) == AsyncThrowingStream<Author, Error>.self)
    }

    @Test("allQuotes accepts filtering parameters")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesParameters() {
        // Test that all parameters are accepted without type errors
        _ = QuoteKit.allQuotes(tags: ["wisdom"], authors: ["einstein"], sortBy: .dateAdded, pageSize: 50)
        _ = QuoteKit.allQuotes(tags: nil, authors: nil, sortBy: nil, pageSize: 100)

        // If we get here without compilation errors, the test passes
        #expect(true)
    }

    @Test("allAuthors accepts filtering parameters")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsParameters() {
        // Test that all parameters are accepted without type errors
        _ = QuoteKit.allAuthors(sortBy: .name, pageSize: 50)
        _ = QuoteKit.allAuthors(sortBy: nil, pageSize: 100)

        // If we get here without compilation errors, the test passes
        #expect(true)
    }
}
