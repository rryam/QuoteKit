//
//  QuoteItemCollectionDecodingTests.swift
//  QuoteKitTests
//
//  Created by Assistant on 02/07/2026.
//

import Foundation
import Testing

@testable import QuoteKit

@Suite("QuoteItemCollection Decoding Tests")
struct QuoteItemCollectionDecodingTests {
    @Test func testDecodesWrappedAPIResponse() throws {
        let jsonString = """
        {
            "data": [
                {
                    "_id": "wrapped-quote",
                    "tags": ["wisdom"],
                    "content": "Wrapped response content",
                    "author": "Wrapped Author",
                    "authorSlug": "wrapped-author",
                    "length": 24,
                    "dateAdded": "2025-01-01T00:00:00Z",
                    "dateModified": "2025-01-02T00:00:00Z"
                }
            ],
            "metadata": {
                "total": 12,
                "page": 0,
                "lastPage": 3,
                "hasNextPage": true,
                "hasPreviousPage": false
            }
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let collection = try decoder.decode(QuoteItemCollection<Quote>.self, from: jsonData)

        #expect(collection.count == 1)
        #expect(collection.totalCount == 12)
        #expect(collection.page == 1)
        #expect(collection.totalPages == 4)
        #expect(collection.lastItemIndex == nil)
        #expect(collection.results.first?.id == "wrapped-quote")
    }

    @Test func testPreservesWrappedItemDecodingFailure() throws {
        let jsonString = """
        {
            "data": [
                {
                    "_id": "malformed-quote",
                    "tags": ["wisdom"],
                    "author": "Wrapped Author",
                    "authorSlug": "wrapped-author"
                }
            ],
            "metadata": {
                "total": 1,
                "page": 0,
                "lastPage": 0,
                "hasNextPage": false,
                "hasPreviousPage": false
            }
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            _ = try decoder.decode(QuoteItemCollection<Quote>.self, from: jsonData)
            Issue.record("Expected wrapped item decoding to fail.")
        } catch DecodingError.keyNotFound(let key, _) {
            #expect(key.stringValue == "content")
        } catch {
            Issue.record("Expected missing content to be preserved, got \\(error).")
        }
    }
}
