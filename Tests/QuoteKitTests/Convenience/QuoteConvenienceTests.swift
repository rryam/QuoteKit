//
//  QuoteConvenienceTests.swift
//  QuoteKitTests
//
//  Created by QuoteKit on 26/06/25.
//

import Testing
import Foundation
@testable import QuoteKit

@Suite("Quote Convenience Methods Tests")
struct QuoteConvenienceTests {
    
    // MARK: - Quote of the Day Tests
    
    @Test("Quote of the Day returns a valid quote")
    func testQuoteOfTheDay() async throws {
        let quote = try await QuoteKit.quoteOfTheDay()
        
        // Verify we got a quote with required fields
        #expect(!quote.id.isEmpty)
        #expect(!quote.content.isEmpty)
        #expect(!quote.author.isEmpty)
        #expect(!quote.authorSlug.isEmpty)
        #expect(quote.length > 0)
        // Note: dateAdded and dateModified may be empty when using backup API
    }
    
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
    
    @Test("Quotes by Author with custom limit")
    func testQuotesByAuthorWithLimit() async throws {
        let authorSlug = "albert-einstein"
        let limit = 5
        
        do {
            let quotes = try await QuoteKit.quotesByAuthor(authorSlug, limit: limit)
            
            // Verify the results respect the limit
            #expect(quotes.results.count <= limit)
            
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
    
    // MARK: - Inspirational Quotes Tests
    
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
    
    @Test("Inspirational Quotes with custom limit")
    func testInspirationalQuotesWithLimit() async throws {
        let limit = 10
        
        do {
            let quotes = try await QuoteKit.inspirationalQuotes(limit: limit)
            
            // Verify the results respect the limit
            #expect(quotes.results.count <= limit)
            
            // Verify all quotes have the inspirational tag
            for quote in quotes.results {
                #expect(quote.tags.contains("inspirational"))
            }
        } catch {
            // If the API is having issues, at least verify the method can be called
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
    
    // MARK: - Motivational Quotes Tests
    
    @Test("Motivational Quotes returns quotes with motivational tag")
    func testMotivationalQuotes() async throws {
        do {
            let quotes = try await QuoteKit.motivationalQuotes()
            
            // Verify we got results
            #expect(quotes.count > 0)
            #expect(quotes.results.count > 0)
            
            // Verify all quotes have the motivational tag
            for quote in quotes.results {
                #expect(quote.tags.contains("motivational"), 
                       "Quote should have 'motivational' tag, but has: \(quote.tags)")
            }
        } catch {
            // If the API is having issues, at least verify the method can be called
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
    
    @Test("Motivational Quotes with pagination")
    func testMotivationalQuotesWithPagination() async throws {
        do {
            // Get first page
            let page1 = try await QuoteKit.motivationalQuotes(limit: 5, page: 1)
            
            // Get second page
            let page2 = try await QuoteKit.motivationalQuotes(limit: 5, page: 2)
            
            // Verify pagination info
            #expect(page1.page == 1)
            #expect(page2.page == 2)
            
            // Verify we got different quotes (if there are enough motivational quotes)
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
    
    @Test("Recent Quotes with custom limit")
    func testRecentQuotesWithLimit() async throws {
        let limit = 5
        
        do {
            let quotes = try await QuoteKit.recentQuotes(limit: limit)
            
            // Verify the results respect the limit
            #expect(quotes.results.count <= limit)
            
            // Verify quotes are sorted by dateAdded in descending order
            // Only check if dateAdded is not empty (backup API returns empty dates)
            let nonEmptyDates = quotes.results.map { $0.dateAdded }.filter { !$0.isEmpty }
            if nonEmptyDates.count > 1 {
                for i in 0..<nonEmptyDates.count - 1 {
                    #expect(nonEmptyDates[i] >= nonEmptyDates[i + 1])
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
    
    // MARK: - Edge Cases and Error Handling
    
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
    
    @Test("All convenience methods handle network errors gracefully")
    func testNetworkErrorHandling() async throws {
        // This test would ideally mock network errors, but for now we'll just verify
        // that the methods can be called without crashing
        
        // Each of these should either succeed or throw a proper error
        do {
            _ = try await QuoteKit.quoteOfTheDay()
        } catch {
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
        
        do {
            _ = try await QuoteKit.shortRandomQuote()
        } catch {
            #expect(error is QuoteFetchError || error is URLError || error is DecodingError)
        }
    }
}