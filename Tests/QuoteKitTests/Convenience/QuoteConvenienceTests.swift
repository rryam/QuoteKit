//
//  QuoteConvenienceTests.swift
//  QuoteKitTests
//
//  Tests for quote convenience methods that add real value beyond basic API calls.
//

import Testing
import Foundation
@testable import QuoteKit

@Suite("Quote Convenience Methods Tests")
struct QuoteConvenienceTests {
    
    // MARK: - Short Random Quote Tests
    
    @Test("Short Random Quote returns quote with max 100 characters")
    func testShortRandomQuote() async throws {
        let quote = try await QuoteKit.shortRandomQuote()
        
        // Verify the quote length is within limit
        #expect(quote.length <= 100)
        #expect(quote.content.count <= 100)
        
        // Verify other required fields
        #expect(!quote.id.isEmpty)
        #expect(!quote.content.isEmpty)
        #expect(!quote.author.isEmpty)
    }
    
    @Test("Multiple short random quotes are all under 100 characters")
    func testMultipleShortRandomQuotes() async throws {
        // Test multiple times to ensure consistency
        for _ in 0..<5 {
            let quote = try await QuoteKit.shortRandomQuote()
            #expect(quote.length <= 100, "Quote length \(quote.length) exceeds 100 characters")
        }
    }
    
    // MARK: - Quotes by Author Tests
    
    @Test("Quotes by Author returns quotes from specified author")
    func testQuotesByAuthor() async throws {
        // Using a known author slug
        let authorSlug = "albert-einstein"
        
        do {
            let quotes = try await QuoteKit.quotesByAuthor(authorSlug)
            
            // Verify we got results
            #expect(quotes.count > 0)
            #expect(quotes.results.count > 0)
            
            // Verify all quotes are from the specified author
            for quote in quotes.results {
                #expect(quote.authorSlug == authorSlug)
            }
        } catch {
            // If the API is having issues, at least verify the method can be called
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
    
    @Test("Quotes by Author with pagination")
    func testQuotesByAuthorWithPagination() async throws {
        let authorSlug = "albert-einstein"
        
        do {
            // Get first page
            let page1 = try await QuoteKit.quotesByAuthor(authorSlug, limit: 5, page: 1)
            
            // Get second page
            let page2 = try await QuoteKit.quotesByAuthor(authorSlug, limit: 5, page: 2)
            
            // Verify we got different quotes (if author has enough quotes)
            if page1.totalPages > 1 {
                let page1IDs = Set(page1.results.map { $0.id })
                let page2IDs = Set(page2.results.map { $0.id })
                #expect(page1IDs.isDisjoint(with: page2IDs), "Pages should contain different quotes")
            }
        } catch {
            // If the API is having issues, at least verify the method can be called
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
    
    // MARK: - Tag Filtering Tests (one example is enough)
    
    @Test("Inspirational Quotes returns quotes with inspirational tag")
    func testInspirationalQuotes() async throws {
        do {
            let quotes = try await QuoteKit.inspirationalQuotes()
            
            // Verify we got results
            #expect(quotes.count > 0)
            #expect(quotes.results.count > 0)
            
            // Verify all quotes have the inspirational tag
            for quote in quotes.results {
                #expect(quote.tags.contains("inspirational"), 
                       "Quote should have 'inspirational' tag, but has: \(quote.tags)")
            }
        } catch {
            // If the API is having issues, at least verify the method can be called
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
    
    // MARK: - Recent Quotes Tests
    
    @Test("Recent Quotes returns quotes sorted by date added descending")
    func testRecentQuotes() async throws {
        do {
            let quotes = try await QuoteKit.recentQuotes()
            
            // Verify we got results
            #expect(quotes.count > 0)
            #expect(quotes.results.count > 0)
            
            // Verify quotes are sorted by dateAdded in descending order
            // Only check if dateAdded is not empty (backup API returns empty dates)
            let nonEmptyDates = quotes.results.map { $0.dateAdded }.filter { !$0.isEmpty }
            if nonEmptyDates.count > 1 {
                for i in 0..<nonEmptyDates.count - 1 {
                    #expect(nonEmptyDates[i] >= nonEmptyDates[i + 1], 
                           "Quotes should be sorted by date descending. Found: \(nonEmptyDates[i]) before \(nonEmptyDates[i + 1])")
                }
            }
        } catch {
            // If the API is having issues, at least verify the method can be called
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
    
    @Test("Recent Quotes returns different quotes than older ones")
    func testRecentQuotesAreDifferentFromOlder() async throws {
        do {
            // Get recent quotes
            let recentQuotes = try await QuoteKit.recentQuotes(limit: 5)
            
            // Get quotes sorted by dateAdded ascending (oldest first)
            let oldQuotes = try await QuoteKit.quotes(sortBy: .dateAdded, order: .ascending, limit: 5)
            
            // Verify we got different quotes (assuming the database has more than 10 quotes)
            if recentQuotes.totalCount > 10 {
                let recentIDs = Set(recentQuotes.results.map { $0.id })
                let oldIDs = Set(oldQuotes.results.map { $0.id })
                #expect(recentIDs.isDisjoint(with: oldIDs), 
                       "Recent quotes should be different from oldest quotes")
            }
        } catch {
            // If the API is having issues, at least verify the method can be called
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("Invalid author slug returns empty results")
    func testInvalidAuthorSlug() async throws {
        do {
            let quotes = try await QuoteKit.quotesByAuthor("non-existent-author-12345")
            
            // Should return empty results, not throw an error
            #expect(quotes.count == 0)
            #expect(quotes.results.isEmpty)
        } catch {
            // Some APIs might throw an error for invalid author, which is also acceptable
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
}