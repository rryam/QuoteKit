//
//  PaginationHelperTests.swift
//  QuoteKit
//
//  Created by QuoteKit on 26/06/2025.
//

import Testing

@testable import QuoteKit

struct PaginationHelperTests {
  // MARK: - Mock Data

  // Mock item for testing
  struct MockItem: Codable, Sendable {
    let id: String
    let name: String
  }

  // Helper function to create mock collections
  func createMockCollection(
    page: Int,
    totalPages: Int,
    count: Int = 10,
    totalCount: Int = 50
  ) -> QuoteItemCollection<MockItem> {
    let items = (1...count).map { MockItem(id: "\($0)", name: "Item \($0)") }
    return QuoteItemCollection(
      count: count,
      totalCount: totalCount,
      page: page,
      totalPages: totalPages,
      lastItemIndex: nil,
      results: items
    )
  }

  // MARK: - hasMorePages() Tests

  @Test func testHasMorePagesWhenMorePagesExist() {
    // Test various scenarios where more pages exist
    let testCases = [
      (page: 1, totalPages: 5, expected: true, description: "First page of multi-page collection"),
      (page: 2, totalPages: 5, expected: true, description: "Middle page of collection"),
      (page: 4, totalPages: 5, expected: true, description: "Second to last page")
    ]

    for testCase in testCases {
      let collection = createMockCollection(
        page: testCase.page,
        totalPages: testCase.totalPages
      )

      let result = QuoteKit.hasMorePages(collection)

      #expect(
        result == testCase.expected,
        "\(testCase.description): Expected \(testCase.expected) but got \(result)"
      )
    }
  }

  @Test func testHasMorePagesWhenNoMorePages() {
    // Test scenarios where no more pages exist
    let testCases = [
      (page: 5, totalPages: 5, description: "Last page of multi-page collection"),
      (page: 1, totalPages: 1, description: "Single page collection"),
      (page: 0, totalPages: 0, description: "Empty collection")
    ]

    for testCase in testCases {
      let collection = createMockCollection(
        page: testCase.page,
        totalPages: testCase.totalPages
      )

      let result = QuoteKit.hasMorePages(collection)

      #expect(
        result == false,
        "\(testCase.description): Expected false but got \(result)"
      )
    }
  }

  @Test func testHasMorePagesEdgeCases() {
    // Test edge cases
    let edgeCases = [
      (page: 0, totalPages: 1, expected: true, description: "Page 0 with total pages 1"),
      (page: -1, totalPages: 5, expected: true, description: "Negative page number"),
      (page: 10, totalPages: 5, expected: false, description: "Page exceeds total pages")
    ]

    for testCase in edgeCases {
      let collection = createMockCollection(
        page: testCase.page,
        totalPages: testCase.totalPages
      )

      let result = QuoteKit.hasMorePages(collection)

      #expect(
        result == testCase.expected,
        "\(testCase.description): Expected \(testCase.expected) but got \(result)"
      )
    }
  }

  // MARK: - nextPage() Tests

  @Test func testNextPageWhenMorePagesExist() {
    // Test getting next page when more pages are available
    let testCases = [
      (page: 1, totalPages: 5, expectedNext: 2, description: "First page to second"),
      (page: 3, totalPages: 5, expectedNext: 4, description: "Middle page navigation"),
      (page: 4, totalPages: 5, expectedNext: 5, description: "Second to last page")
    ]

    for testCase in testCases {
      let collection = createMockCollection(
        page: testCase.page,
        totalPages: testCase.totalPages
      )

      let nextPage = QuoteKit.nextPage(collection)

      let message = "\(testCase.description): Expected page \(testCase.expectedNext) " +
                   "but got \(String(describing: nextPage))"
      #expect(nextPage == testCase.expectedNext, Comment(rawValue: message))
    }
  }

  @Test func testNextPageWhenNoMorePages() {
    // Test getting next page when on last page
    let testCases = [
      (page: 5, totalPages: 5, description: "Last page of multi-page collection"),
      (page: 1, totalPages: 1, description: "Single page collection"),
      (page: 0, totalPages: 0, description: "Empty collection")
    ]

    for testCase in testCases {
      let collection = createMockCollection(
        page: testCase.page,
        totalPages: testCase.totalPages
      )

      let nextPage = QuoteKit.nextPage(collection)

      #expect(
        nextPage == nil,
        "\(testCase.description): Expected nil but got \(String(describing: nextPage))"
      )
    }
  }

  @Test func testNextPageEdgeCases() {
    // Test edge cases for nextPage
    let edgeCases = [
      (page: 0, totalPages: 3, expectedNext: 1, description: "Page 0 to page 1"),
      (page: -1, totalPages: 5, expectedNext: 0, description: "Negative page number"),
      (page: 10, totalPages: 5, expectedNext: nil, description: "Page exceeds total pages")
    ]

    for testCase in edgeCases {
      let collection = createMockCollection(
        page: testCase.page,
        totalPages: testCase.totalPages
      )

      let nextPage = QuoteKit.nextPage(collection)

      let message = "\(testCase.description): Expected \(String(describing: testCase.expectedNext)) " +
                   "but got \(String(describing: nextPage))"
      #expect(nextPage == testCase.expectedNext, Comment(rawValue: message))
    }
  }

  // MARK: - Integration Tests

  @Test func testPaginationWorkflow() {
    // Test a complete pagination workflow
    var currentPage = 1
    let totalPages = 3
    var pages: [Int] = []

    // Simulate navigating through all pages
    while currentPage <= totalPages {
      let collection = createMockCollection(page: currentPage, totalPages: totalPages)
      pages.append(currentPage)

      if let next = QuoteKit.nextPage(collection) {
        currentPage = next
      } else {
        break
      }
    }

    #expect(pages == [1, 2, 3], "Should have navigated through all pages")
  }

  @Test func testPaginationWithDifferentItemTypes() {
    // Test that pagination works with different generic types

    // Test with Quote type simulation
    struct MockQuote: Codable, Sendable {
      let content: String
      let author: String
    }

    let quoteItems = [MockQuote(content: "Test quote", author: "Test Author")]
    let quoteCollection = QuoteItemCollection(
      count: 1,
      totalCount: 10,
      page: 1,
      totalPages: 10,
      lastItemIndex: nil,
      results: quoteItems
    )

    #expect(QuoteKit.hasMorePages(quoteCollection) == true)
    #expect(QuoteKit.nextPage(quoteCollection) == 2)

    // Test with Author type simulation
    struct MockAuthor: Codable, Sendable {
      let name: String
      let slug: String
    }

    let authorItems = [MockAuthor(name: "Author Name", slug: "author-name")]
    let authorCollection = QuoteItemCollection(
      count: 1,
      totalCount: 1,
      page: 1,
      totalPages: 1,
      lastItemIndex: nil,
      results: authorItems
    )

    #expect(QuoteKit.hasMorePages(authorCollection) == false)
    #expect(QuoteKit.nextPage(authorCollection) == nil)
  }
}
