//
//  AuthorsDataTests.swift
//  AuthorsDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest

@testable import QuoteKit

final class AuthorsDataTests: XCTestCase {
  func testAuthorMatchesParticularID() async throws {
    do {
      let author = try await QuoteKit.author(id: "XYxYtSeixS-o")
      let unwrappedAuthor = try XCTUnwrap(author)

      XCTAssertEqual(unwrappedAuthor.link, "https://en.wikipedia.org/wiki/Aesop")
      let expectedBio = "Aesop (c. 620 – 564 BCE) was a Greek fabulist and storyteller " +
                       "credited with a number of fables now collectively known as Aesop's Fables."
      XCTAssertEqual(unwrappedAuthor.bio, expectedBio)
      XCTAssertEqual(unwrappedAuthor.name, "Aesop")
      XCTAssertEqual(unwrappedAuthor.slug, "aesop")
      XCTAssertEqual(unwrappedAuthor.description, "Ancient Greek storyteller")
      XCTAssertEqual(unwrappedAuthor.quoteCount, 10)
    } catch {
      XCTFail("Expected author, but failed \(error).")
    }
  }

  func testAuthorsReturnsManyAuthors() async throws {
    do {
      let authors = try await QuoteKit.authors()
      let unwrappedAuthors = try XCTUnwrap(authors)

      XCTAssertGreaterThan(unwrappedAuthors.count, 1)
    } catch {
      XCTFail("Expected authors, but failed \(error).")
    }
  }

  func testAuthorsSearchForParticularQuery() async throws {
    do {
      let authors = try await QuoteKit.searchAuthors(for: "aesop")
      let unwrappedAuthor = try XCTUnwrap(authors.results.first)

      XCTAssertEqual(unwrappedAuthor.link, "https://en.wikipedia.org/wiki/Aesop")
      let expectedBio = "Aesop (c. 620 – 564 BCE) was a Greek fabulist and storyteller " +
                       "credited with a number of fables now collectively known as Aesop's Fables."
      XCTAssertEqual(unwrappedAuthor.bio, expectedBio)
      XCTAssertEqual(unwrappedAuthor.name, "Aesop")
      XCTAssertEqual(unwrappedAuthor.slug, "aesop")
      XCTAssertEqual(unwrappedAuthor.description, "Ancient Greek storyteller")
      XCTAssertEqual(unwrappedAuthor.quoteCount, 10)
    }
  }
}
