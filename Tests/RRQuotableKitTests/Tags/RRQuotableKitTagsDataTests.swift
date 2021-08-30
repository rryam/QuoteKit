//
//  RRQuotableKitTagsDataTests.swift
//  RRQuotableKitTagsDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import RRQuotableKit

final class RRQuotableKitTagsDataTests: XCTestCase {
    func testTagsReturnsManyTags() async throws {
        do {
            let tags = try await RRQuotableKit.tags()
            let unwrappedTags = try XCTUnwrap(tags)

            XCTAssertGreaterThan(unwrappedTags.count, 1)
         } catch {
             XCTFail("Expected tags, but failed \(error).")
         }
    }
}
