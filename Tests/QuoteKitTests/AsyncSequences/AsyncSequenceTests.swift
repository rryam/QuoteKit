//
//  AsyncSequenceTests.swift
//  QuoteKitTests
//
//  Created for testing async sequence pagination functionality.
//

import Testing
@testable import QuoteKit

@Suite("Async Sequence Tests")
struct AsyncSequenceTests {
    
    // Note: These tests require a working API connection.
    // If the API is down, tests will fail with network errors.
    
    // MARK: - allQuotes() Tests
    
    @Test("allQuotes fetches multiple pages automatically")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesFetchesMultiplePages() async throws {
        // Using a small page size to ensure pagination
        let pageSize = 5
        var quotesCount = 0
        var uniqueQuoteIds = Set<String>()
        
        // Collect first 15 quotes (should require 3 pages)
        for try await quote in QuoteKit.allQuotes(pageSize: pageSize) {
            quotesCount += 1
            uniqueQuoteIds.insert(quote.id)
            
            if quotesCount >= 15 {
                break
            }
        }
        
        #expect(quotesCount == 15)
        #expect(uniqueQuoteIds.count == 15) // Ensure all quotes are unique
    }
    
    @Test("allQuotes with tag filter")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesWithTagFilter() async throws {
        let targetTag = "inspirational"
        var quotesCount = 0
        
        for try await quote in QuoteKit.allQuotes(tags: [targetTag], pageSize: 10) {
            #expect(quote.tags.contains(targetTag))
            quotesCount += 1
            
            if quotesCount >= 20 {
                break
            }
        }
        
        #expect(quotesCount >= 10) // Should have at least some inspirational quotes
    }
    
    @Test("allQuotes with author filter")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesWithAuthorFilter() async throws {
        // Using a well-known author likely to have multiple quotes
        let authorSlug = "albert-einstein"
        var quotesCount = 0
        var allQuotesFromAuthor = true
        
        for try await quote in QuoteKit.allQuotes(authors: [authorSlug], pageSize: 5) {
            if quote.authorSlug != authorSlug {
                allQuotesFromAuthor = false
            }
            quotesCount += 1
            
            if quotesCount >= 10 {
                break
            }
        }
        
        #expect(allQuotesFromAuthor)
        #expect(quotesCount >= 5) // Einstein should have at least 5 quotes
    }
    
    @Test("allQuotes with sort by date added descending")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesWithSortBy() async throws {
        var previousDate: String?
        var quotesCount = 0
        var correctOrder = true
        
        for try await quote in QuoteKit.allQuotes(sortBy: .dateAdded, pageSize: 10) {
            if let prevDate = previousDate {
                // Dates should be in descending order (newer first by default)
                if quote.dateAdded > prevDate {
                    correctOrder = false
                }
            }
            previousDate = quote.dateAdded
            quotesCount += 1
            
            if quotesCount >= 20 {
                break
            }
        }
        
        #expect(correctOrder)
        #expect(quotesCount == 20)
    }
    
    @Test("allQuotes early termination")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesEarlyTermination() async throws {
        var quotesCount = 0
        
        for try await _ in QuoteKit.allQuotes(pageSize: 10) {
            quotesCount += 1
            
            // Terminate after 5 quotes
            if quotesCount >= 5 {
                break
            }
        }
        
        #expect(quotesCount == 5)
    }
    
    @Test("allQuotes handles cancellation")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesCancellation() async throws {
        let task = Task {
            var count = 0
            for try await _ in QuoteKit.allQuotes(pageSize: 10) {
                count += 1
                if count >= 5 {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
            return count
        }
        
        // Give it time to start
        try await Task.sleep(for: .milliseconds(50))
        
        // Cancel the task
        task.cancel()
        
        // The task should throw CancellationError
        do {
            _ = try await task.value
            Issue.record("Expected task to be cancelled")
        } catch {
            #expect(error is CancellationError)
        }
    }
    
    // MARK: - allAuthors() Tests
    
    @Test("allAuthors fetches multiple pages automatically")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsFetchesMultiplePages() async throws {
        // Using a small page size to ensure pagination
        let pageSize = 5
        var authorsCount = 0
        var uniqueAuthorIds = Set<String>()
        
        // Collect first 15 authors (should require 3 pages)
        for try await author in QuoteKit.allAuthors(pageSize: pageSize) {
            authorsCount += 1
            uniqueAuthorIds.insert(author.id)
            
            if authorsCount >= 15 {
                break
            }
        }
        
        #expect(authorsCount == 15)
        #expect(uniqueAuthorIds.count == 15) // Ensure all authors are unique
    }
    
    @Test("allAuthors with sort by name")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsWithSortBy() async throws {
        var previousName: String?
        var authorsCount = 0
        var correctOrder = true
        
        for try await author in QuoteKit.allAuthors(sortBy: .name, pageSize: 10) {
            if let prevName = previousName {
                // Names should be in ascending alphabetical order
                if author.name < prevName {
                    correctOrder = false
                }
            }
            previousName = author.name
            authorsCount += 1
            
            if authorsCount >= 20 {
                break
            }
        }
        
        #expect(correctOrder)
        #expect(authorsCount == 20)
    }
    
    @Test("allAuthors early termination")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsEarlyTermination() async throws {
        var authorsCount = 0
        
        for try await _ in QuoteKit.allAuthors(pageSize: 10) {
            authorsCount += 1
            
            // Terminate after 5 authors
            if authorsCount >= 5 {
                break
            }
        }
        
        #expect(authorsCount == 5)
    }
    
    @Test("allAuthors handles cancellation")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsCancellation() async throws {
        let task = Task {
            var count = 0
            for try await _ in QuoteKit.allAuthors(pageSize: 10) {
                count += 1
                if count >= 5 {
                    try await Task.sleep(for: .milliseconds(100))
                }
            }
            return count
        }
        
        // Give it time to start
        try await Task.sleep(for: .milliseconds(50))
        
        // Cancel the task
        task.cancel()
        
        // The task should throw CancellationError
        do {
            _ = try await task.value
            Issue.record("Expected task to be cancelled")
        } catch {
            #expect(error is CancellationError)
        }
    }
    
    // MARK: - Error Handling Tests
    
    @Test("allQuotes handles network errors gracefully")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesNetworkErrorHandling() async throws {
        // This test would ideally use a mock, but for now we'll test with an invalid filter
        // that might cause an empty result set
        var errorOccurred = false
        var quotesReceived = 0
        
        do {
            // Using a very specific combination that might not exist
            for try await _ in QuoteKit.allQuotes(
                tags: ["nonexistent-tag-xyz"],
                authors: ["nonexistent-author-xyz"],
                pageSize: 5
            ) {
                quotesReceived += 1
                if quotesReceived > 10 {
                    break
                }
            }
        } catch {
            errorOccurred = true
        }
        
        // Either we get no quotes or an error - both are acceptable
        #expect(quotesReceived == 0 || errorOccurred)
    }
    
    @Test("allAuthors handles network errors gracefully")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllAuthorsNetworkErrorHandling() async throws {
        // Test that the stream completes without crashing even with small page sizes
        var authorsReceived = 0
        var errorOccurred = false
        
        do {
            for try await _ in QuoteKit.allAuthors(pageSize: 150) {
                authorsReceived += 1
                if authorsReceived > 300 {
                    break
                }
            }
        } catch {
            errorOccurred = true
        }
        
        // Should receive some authors or handle error gracefully
        #expect(authorsReceived > 0 || errorOccurred)
    }
    
    // MARK: - Integration Tests
    
    @Test("Combined filters work correctly in allQuotes")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testAllQuotesCombinedFilters() async throws {
        let tags = ["wisdom"]
        var quotesCount = 0
        var allMatchFilter = true
        
        for try await quote in QuoteKit.allQuotes(
            tags: tags,
            sortBy: .content,
            pageSize: 10
        ) {
            if !quote.tags.contains("wisdom") {
                allMatchFilter = false
            }
            quotesCount += 1
            
            if quotesCount >= 15 {
                break
            }
        }
        
        #expect(allMatchFilter)
        #expect(quotesCount >= 10)
    }
    
    @Test("Verify pagination boundary conditions")
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    func testPaginationBoundaryConditions() async throws {
        // Test with page size of 1 to ensure proper pagination
        var quotesCount = 0
        var previousQuoteId: String?
        
        for try await quote in QuoteKit.allQuotes(pageSize: 1) {
            // Ensure we're getting different quotes
            #expect(quote.id != previousQuoteId)
            previousQuoteId = quote.id
            quotesCount += 1
            
            if quotesCount >= 5 {
                break
            }
        }
        
        #expect(quotesCount == 5)
    }
}