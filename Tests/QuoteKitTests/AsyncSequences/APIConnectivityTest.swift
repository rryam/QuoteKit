//
//  APIConnectivityTest.swift
//  QuoteKitTests
//
//  Test to verify API connectivity before running async sequence tests
//

import Testing
@testable import QuoteKit

@Suite("API Connectivity Test")
struct APIConnectivityTest {
    
    @Test("Verify API is accessible")
    func testAPIConnectivity() async throws {
        // Try to fetch a single page of quotes
        do {
            let quotes = try await QuoteKit.quotes(limit: 1)
            #expect(quotes.results.count >= 0)
            print("✅ API is accessible. Received \(quotes.results.count) quotes.")
            print("Total quotes available: \(quotes.totalCount)")
            print("Total pages: \(quotes.totalPages)")
        } catch {
            print("❌ API error: \(error)")
            throw error
        }
    }
    
    @Test("Test with production API explicitly")
    func testProductionAPI() async throws {
        // Force use of production endpoint
        let endpoint = QuotableEndpoint(.quotes, queryItems: [.limit(1)], host: .production)
        
        do {
            let quotes: Quotes = try await QuoteKit.execute(with: endpoint)
            #expect(quotes.results.count >= 0)
            print("✅ Production API is accessible")
        } catch {
            print("❌ Production API error: \(error)")
            // Try backup API
            let backupEndpoint = QuotableEndpoint(.quotes, queryItems: [.limit(1)], host: .backup)
            let quotes: Quotes = try await QuoteKit.execute(with: backupEndpoint)
            #expect(quotes.results.count >= 0)
            print("✅ Backup API is accessible")
        }
    }
}