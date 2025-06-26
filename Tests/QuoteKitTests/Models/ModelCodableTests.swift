//
//  ModelCodableTests.swift
//  QuoteKitTests
//
//  Created by Assistant on 26/06/2025.
//

import Foundation
import Testing

@testable import QuoteKit

@Suite("Model Codable Tests")
struct ModelCodableTests {
    // MARK: - Quote Tests

    @Test func testQuoteEncodingAndDecoding() throws {
        let originalQuote = Quote(
            id: "test123",
            tags: ["wisdom", "life"],
            content: "Test quote content",
            author: "Test Author",
            authorSlug: "test-author",
            length: 18,
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T11:00:00Z"
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(originalQuote)
        let decodedQuote = try decoder.decode(Quote.self, from: encodedData)

        #expect(decodedQuote == originalQuote)
        #expect(decodedQuote.id == originalQuote.id)
        #expect(decodedQuote.tags == originalQuote.tags)
        #expect(decodedQuote.content == originalQuote.content)
        #expect(decodedQuote.author == originalQuote.author)
        #expect(decodedQuote.authorSlug == originalQuote.authorSlug)
        #expect(decodedQuote.length == originalQuote.length)
        #expect(decodedQuote.dateAdded == originalQuote.dateAdded)
        #expect(decodedQuote.dateModified == originalQuote.dateModified)
    }

    @Test func testQuoteDecodingFromAPIResponse() throws {
        let jsonString = """
        {
            "_id": "api123",
            "tags": ["motivation", "success"],
            "content": "Success is not final, failure is not fatal.",
            "author": "Winston Churchill",
            "authorSlug": "winston-churchill",
            "length": 44,
            "dateAdded": "2025-01-01T00:00:00Z",
            "dateModified": "2025-01-02T00:00:00Z"
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let quote = try decoder.decode(Quote.self, from: jsonData)

        #expect(quote.id == "api123")
        #expect(quote.tags == ["motivation", "success"])
        #expect(quote.content == "Success is not final, failure is not fatal.")
        #expect(quote.author == "Winston Churchill")
        #expect(quote.authorSlug == "winston-churchill")
        #expect(quote.length == 44)
        #expect(quote.dateAdded == "2025-01-01T00:00:00Z")
        #expect(quote.dateModified == "2025-01-02T00:00:00Z")
    }

    @Test func testQuoteWithEmptyTags() throws {
        let quote = Quote(
            id: "empty123",
            tags: [],
            content: "Quote without tags",
            author: "Anonymous",
            authorSlug: "anonymous",
            length: 18,
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z"
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(quote)
        let decodedQuote = try decoder.decode(Quote.self, from: encodedData)

        #expect(decodedQuote == quote)
        #expect(decodedQuote.tags.isEmpty)
    }

    // MARK: - Author Tests

    @Test func testAuthorEncodingAndDecoding() throws {
        let originalAuthor = Author(
            id: "author123",
            link: "https://example.com/author",
            bio: "Test author bio",
            description: "Test author description",
            name: "Test Author",
            quoteCount: 42,
            slug: "test-author",
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T11:00:00Z",
            quotes: nil
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(originalAuthor)
        let decodedAuthor = try decoder.decode(Author.self, from: encodedData)

        #expect(decodedAuthor == originalAuthor)
        #expect(decodedAuthor.id == originalAuthor.id)
        #expect(decodedAuthor.link == originalAuthor.link)
        #expect(decodedAuthor.bio == originalAuthor.bio)
        #expect(decodedAuthor.description == originalAuthor.description)
        #expect(decodedAuthor.name == originalAuthor.name)
        #expect(decodedAuthor.quoteCount == originalAuthor.quoteCount)
        #expect(decodedAuthor.slug == originalAuthor.slug)
        #expect(decodedAuthor.dateAdded == originalAuthor.dateAdded)
        #expect(decodedAuthor.dateModified == originalAuthor.dateModified)
        #expect(decodedAuthor.quotes == nil)
    }

    @Test func testAuthorDecodingFromAPIResponse() throws {
        let jsonString = """
        {
            "_id": "api-author123",
            "link": "https://api.example.com/author",
            "bio": "API author bio",
            "description": "API author description",
            "name": "API Author",
            "quoteCount": 100,
            "slug": "api-author",
            "dateAdded": "2025-01-01T00:00:00Z",
            "dateModified": "2025-01-02T00:00:00Z"
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let author = try decoder.decode(Author.self, from: jsonData)

        #expect(author.id == "api-author123")
        #expect(author.link == "https://api.example.com/author")
        #expect(author.bio == "API author bio")
        #expect(author.description == "API author description")
        #expect(author.name == "API Author")
        #expect(author.quoteCount == 100)
        #expect(author.slug == "api-author")
        #expect(author.dateAdded == "2025-01-01T00:00:00Z")
        #expect(author.dateModified == "2025-01-02T00:00:00Z")
        #expect(author.quotes == nil)
    }

    @Test func testAuthorWithQuotes() throws {
        let quote1 = Quote(
            id: "q1",
            tags: ["tag1"],
            content: "Quote 1",
            author: "Author Name",
            authorSlug: "author-name",
            length: 7,
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z"
        )

        let quote2 = Quote(
            id: "q2",
            tags: ["tag2"],
            content: "Quote 2",
            author: "Author Name",
            authorSlug: "author-name",
            length: 7,
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z"
        )

        let author = Author(
            id: "author-with-quotes",
            link: "https://example.com",
            bio: "Bio",
            description: "Description",
            name: "Author Name",
            quoteCount: 2,
            slug: "author-name",
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z",
            quotes: [quote1, quote2]
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(author)
        let decodedAuthor = try decoder.decode(Author.self, from: encodedData)

        #expect(decodedAuthor.quotes?.count == 2)
        #expect(decodedAuthor.quotes?[0] == quote1)
        #expect(decodedAuthor.quotes?[1] == quote2)
    }

    // MARK: - QuoteItemCollection Tests

    @Test func testQuoteItemCollectionWithQuotes() throws {
        let quote1 = Quote(
            id: "q1",
            tags: ["tag1"],
            content: "Quote 1",
            author: "Author 1",
            authorSlug: "author-1",
            length: 7,
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z"
        )

        let quote2 = Quote(
            id: "q2",
            tags: ["tag2"],
            content: "Quote 2",
            author: "Author 2",
            authorSlug: "author-2",
            length: 7,
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z"
        )

        let collection = QuoteItemCollection(
            count: 2,
            totalCount: 100,
            page: 1,
            totalPages: 50,
            lastItemIndex: 2,
            results: [quote1, quote2]
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(collection)
        let decodedCollection = try decoder.decode(QuoteItemCollection<Quote>.self, from: encodedData)

        #expect(decodedCollection.count == collection.count)
        #expect(decodedCollection.totalCount == collection.totalCount)
        #expect(decodedCollection.page == collection.page)
        #expect(decodedCollection.totalPages == collection.totalPages)
        #expect(decodedCollection.lastItemIndex == collection.lastItemIndex)
        #expect(decodedCollection.results.count == 2)
        #expect(decodedCollection.results[0] == quote1)
        #expect(decodedCollection.results[1] == quote2)
    }

    @Test func testQuoteItemCollectionWithAuthors() throws {
        let author1 = Author(
            id: "a1",
            link: "https://example.com/a1",
            bio: "Bio 1",
            description: "Description 1",
            name: "Author 1",
            quoteCount: 10,
            slug: "author-1",
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z",
            quotes: nil
        )

        let author2 = Author(
            id: "a2",
            link: "https://example.com/a2",
            bio: "Bio 2",
            description: "Description 2",
            name: "Author 2",
            quoteCount: 20,
            slug: "author-2",
            dateAdded: "2025-06-26T10:00:00Z",
            dateModified: "2025-06-26T10:00:00Z",
            quotes: nil
        )

        let collection = QuoteItemCollection(
            count: 2,
            totalCount: 50,
            page: 1,
            totalPages: 25,
            lastItemIndex: nil,
            results: [author1, author2]
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(collection)
        let decodedCollection = try decoder.decode(QuoteItemCollection<Author>.self, from: encodedData)

        #expect(decodedCollection.count == collection.count)
        #expect(decodedCollection.totalCount == collection.totalCount)
        #expect(decodedCollection.page == collection.page)
        #expect(decodedCollection.totalPages == collection.totalPages)
        #expect(decodedCollection.lastItemIndex == nil)
        #expect(decodedCollection.results.count == 2)
        #expect(decodedCollection.results[0] == author1)
        #expect(decodedCollection.results[1] == author2)
    }

    @Test func testQuoteItemCollectionWithEmptyResults() throws {
        let collection = QuoteItemCollection<Quote>(
            count: 0,
            totalCount: 0,
            page: 1,
            totalPages: 0,
            lastItemIndex: nil,
            results: []
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let encodedData = try encoder.encode(collection)
        let decodedCollection = try decoder.decode(QuoteItemCollection<Quote>.self, from: encodedData)

        #expect(decodedCollection.results.isEmpty)
        #expect(decodedCollection.totalCount == 0)
        #expect(decodedCollection.page == 1)
        #expect(decodedCollection.totalPages == 0)
        #expect(decodedCollection.lastItemIndex == nil)
        #expect(decodedCollection.results.isEmpty)
    }
}
