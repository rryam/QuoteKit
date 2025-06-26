//
//  AsyncSequenceLogicTests.swift
//  QuoteKitTests
//
//  Tests for async sequence logic that work regardless of API status
//

import Testing
@testable import QuoteKit

@Suite("Async Sequence Logic Tests")
struct AsyncSequenceLogicTests {
    
    // MARK: - Test Async Sequence Structure
    
    @Test("allQuotes returns AsyncThrowingStream")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesReturnsCorrectType() async throws {
        // Verify the method exists and returns the correct type
        let sequence = QuoteKit.allQuotes()
        
        // Type check - this will compile only if the type is correct
        let _: AsyncThrowingStream<Quote, Error> = sequence
        
        // We can't easily test the actual iteration without a working API,
        // but we can verify the sequence is created
        #expect(true) // If we get here, the type is correct
    }
    
    @Test("allAuthors returns AsyncThrowingStream")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsReturnsCorrectType() async throws {
        // Verify the method exists and returns the correct type
        let sequence = QuoteKit.allAuthors()
        
        // Type check
        let _: AsyncThrowingStream<Author, Error> = sequence
        
        #expect(true) // If we get here, the type is correct
    }
    
    @Test("allQuotes accepts filter parameters")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesAcceptsParameters() async throws {
        // Test that all parameters compile correctly
        let _ = QuoteKit.allQuotes(
            tags: ["wisdom", "life"],
            authors: ["albert-einstein"],
            sortBy: .dateAdded,
            pageSize: 50
        )
        
        let _ = QuoteKit.allQuotes(
            tags: nil,
            authors: nil,
            sortBy: nil,
            pageSize: 100
        )
        
        #expect(true) // Parameters accepted correctly
    }
    
    @Test("allAuthors accepts filter parameters")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsAcceptsParameters() async throws {
        // Test that all parameters compile correctly
        let _ = QuoteKit.allAuthors(
            sortBy: .name,
            pageSize: 50
        )
        
        let _ = QuoteKit.allAuthors(
            sortBy: nil,
            pageSize: 100
        )
        
        #expect(true) // Parameters accepted correctly
    }
    
    // MARK: - Test Pagination Helper Functions
    
    @Test("hasMorePages works correctly")
    func testHasMorePages() {
        // Create test collections
        let quotesWithMorePages = Quotes(
            count: 20,
            totalCount: 100,
            page: 1,
            totalPages: 5,
            lastItemIndex: 19,
            results: []
        )
        
        let quotesOnLastPage = Quotes(
            count: 20,
            totalCount: 100,
            page: 5,
            totalPages: 5,
            lastItemIndex: 99,
            results: []
        )
        
        let authorsWithMorePages = Authors(
            count: 10,
            totalCount: 50,
            page: 2,
            totalPages: 5,
            lastItemIndex: 19,
            results: []
        )
        
        let authorsOnLastPage = Authors(
            count: 10,
            totalCount: 50,
            page: 5,
            totalPages: 5,
            lastItemIndex: 49,
            results: []
        )
        
        #expect(QuoteKit.hasMorePages(quotesWithMorePages) == true)
        #expect(QuoteKit.hasMorePages(quotesOnLastPage) == false)
        #expect(QuoteKit.hasMorePages(authorsWithMorePages) == true)
        #expect(QuoteKit.hasMorePages(authorsOnLastPage) == false)
    }
    
    @Test("nextPage works correctly")
    func testNextPage() {
        let quotesPage1 = Quotes(
            count: 20,
            totalCount: 100,
            page: 1,
            totalPages: 5,
            lastItemIndex: 19,
            results: []
        )
        
        let quotesLastPage = Quotes(
            count: 20,
            totalCount: 100,
            page: 5,
            totalPages: 5,
            lastItemIndex: 99,
            results: []
        )
        
        let authorsPage3 = Authors(
            count: 10,
            totalCount: 50,
            page: 3,
            totalPages: 5,
            lastItemIndex: 29,
            results: []
        )
        
        #expect(QuoteKit.nextPage(quotesPage1) == 2)
        #expect(QuoteKit.nextPage(quotesLastPage) == nil)
        #expect(QuoteKit.nextPage(authorsPage3) == 4)
    }
    
    // MARK: - Test Async Stream Behavior (Mock)
    
    @Test("Async stream can be cancelled")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAsyncStreamCancellation() async throws {
        // Create a simple async stream to test cancellation behavior
        let stream = AsyncThrowingStream<Int, Error> { continuation in
            Task { @Sendable in
                for i in 0..<100 {
                    continuation.yield(i)
                    try await Task.sleep(for: .milliseconds(10))
                }
                continuation.finish()
            }
        }
        
        let task = Task {
            var count = 0
            for try await _ in stream {
                count += 1
                if count >= 5 {
                    break
                }
            }
            return count
        }
        
        let result = try await task.value
        #expect(result == 5)
    }
    
    @Test("Async stream handles errors properly")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAsyncStreamErrorHandling() async throws {
        struct TestError: Error {}
        
        let stream = AsyncThrowingStream<Int, Error> { continuation in
            Task { @Sendable in
                continuation.yield(1)
                continuation.yield(2)
                continuation.finish(throwing: TestError())
            }
        }
        
        var values: [Int] = []
        var errorThrown = false
        
        do {
            for try await value in stream {
                values.append(value)
            }
        } catch {
            errorThrown = true
        }
        
        #expect(values == [1, 2])
        #expect(errorThrown == true)
    }
}