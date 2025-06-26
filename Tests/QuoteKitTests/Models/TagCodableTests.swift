//
//  TagCodableTests.swift
//  QuoteKitTests
//
//  Created by Assistant on 26/06/2025.
//

import XCTest

@testable import QuoteKit

// Using XCTest to avoid conflicts with Testing.Tag
final class TagCodableTests: XCTestCase {
    func testTagDecoding() throws {
        let jsonString = """
        {
            "_id": "tag123",
            "name": "technology",
            "dateAdded": "2025-01-01T00:00:00Z",
            "dateModified": "2025-01-02T00:00:00Z",
            "quoteCount": 50
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()

        let tag = try decoder.decode(Tag.self, from: jsonData)

        XCTAssertEqual(tag.id, "tag123")
        XCTAssertEqual(tag.name, "technology")
        XCTAssertEqual(tag.dateAdded, "2025-01-01T00:00:00Z")
        XCTAssertEqual(tag.dateModified, "2025-01-02T00:00:00Z")
        XCTAssertEqual(tag.quoteCount, 50)
    }

    func testTagEquatable() {
        let tag1 = Tag(
            id: "tag1",
            name: "technology",
            dateAdded: "2025-01-01T00:00:00Z",
            dateModified: "2025-01-01T00:00:00Z",
            quoteCount: 10
        )

        // Exact same tag
        let tag2 = Tag(
            id: "tag1",
            name: "technology",
            dateAdded: "2025-01-01T00:00:00Z",
            dateModified: "2025-01-01T00:00:00Z",
            quoteCount: 10
        )

        // Different tag
        let tag3 = Tag(
            id: "tag2",
            name: "science",
            dateAdded: "2025-01-02T00:00:00Z",
            dateModified: "2025-01-02T00:00:00Z",
            quoteCount: 20
        )

        XCTAssertEqual(tag1, tag2)  // Exact same properties, should be equal
        XCTAssertNotEqual(tag1, tag3)  // Different properties, should not be equal
    }

    func testTagCapitalisedName() {
        let tag = Tag(
            id: "tag123",
            name: "machine-learning",
            dateAdded: "2025-01-01T00:00:00Z",
            dateModified: "2025-01-01T00:00:00Z",
            quoteCount: 25
        )

        XCTAssertEqual(tag.capitalisedName, "Machine Learning")
    }
}
