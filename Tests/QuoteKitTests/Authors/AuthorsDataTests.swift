//
//  AuthorsDataTests.swift
//  AuthorsDataTests
//
//  Created by Rudrank Riyam on 30/08/21.
//

import XCTest
@testable import QuoteKit

final class AuthorsDataTests: XCTestCase {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testAuthorsReturnsManyAuthors() async throws {
        do {
            let authors = try await QuoteKit.authors()
            let unwrappedAuthors = try XCTUnwrap(authors)
            
            XCTAssertGreaterThan(unwrappedAuthors.count, 1)
        } catch {
            XCTFail("Expected authors, but failed \(error).")
        }
    }
    
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testAuthorsSearchForParticularQuery() async throws {
        do {
            let authors = try await QuoteKit.searchAuthors(for: "aesop")
            let unwrappedAuthor = try XCTUnwrap(authors?.results.first)
            
            XCTAssertEqual(unwrappedAuthor.link, "https://en.wikipedia.org/wiki/Aesop")
            XCTAssertEqual(unwrappedAuthor.bio, "Aesop (c. 620 – 564 BCE) was a Greek fabulist and storyteller credited with a number of fables now collectively known as Aesop's Fables.")
            XCTAssertEqual(unwrappedAuthor.name, "Aesop")
            XCTAssertEqual(unwrappedAuthor.slug, "aesop")
            XCTAssertEqual(unwrappedAuthor.description, "Ancient Greek storyteller")
            XCTAssertEqual(unwrappedAuthor.quoteCount, 2)
        }
    }
}
