//
//  QuoteKitAuthorsDataTests.swift
//  QuoteKitAuthorsDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import QuoteKit

final class QuoteKitAuthorsDataTests: XCTestCase {
    func testAuthorMatchesParticularID() async throws {
        do {
            let author = try await QuoteKit.author(id: "XYxYtSeixS-o")
            let unwrappedAuthor = try XCTUnwrap(author)
            
            XCTAssertEqual(unwrappedAuthor.link, "https://en.wikipedia.org/wiki/Aesop")
            XCTAssertEqual(unwrappedAuthor.bio, "Aesop (c. 620 – 564 BCE) was a Greek fabulist and storyteller credited with a number of fables now collectively known as Aesop's Fables.")
            XCTAssertEqual(unwrappedAuthor.name, "Aesop")
            XCTAssertEqual(unwrappedAuthor.slug, "aesop")
            XCTAssertEqual(unwrappedAuthor.description, "Ancient Greek storyteller")
            XCTAssertEqual(unwrappedAuthor.quoteCount, 2)
        } catch {
            XCTFail("Expected author, but failed \(error).")
        }
    }
}
