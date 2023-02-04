//
//  QuoteKitTagsDataTests.swift
//  QuoteKitTagsDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

@testable import QuoteKit
import XCTest

final class QuoteKitTagsDataTests: XCTestCase {
  func testTagsReturnsManyTags() async throws {
    do {
      let tags = try await QuoteKit.tags()
      let unwrappedTags = try XCTUnwrap(tags)
      
      XCTAssertGreaterThan(unwrappedTags.count, 1)
    } catch {
      XCTFail("Expected tags, but failed \(error).")
    }
  }
}
