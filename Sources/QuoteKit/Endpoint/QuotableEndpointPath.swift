//
//  QuotableEndpointPath.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 29/08/21.
//

import Foundation

/// An enum that represents the path component for a Quotable API endpoint.
///
/// Use this enum to specify the path component for a specific endpoint on the Quotable API.
///
/// Example usage:
///
/// ```
/// let path: QuotableEndpointPath = .randomQuote
/// ```
public enum QuotableEndpointPath: CustomStringConvertible {

  /// The path for the quotes endpoint.
  case quotes

  /// The path for the random quote endpoint.
  case randomQuote

  /// The path for the authors endpoint.
  case authors

  /// The path for the tags endpoint.
  case tags

  /// The path for a specific quote, identified by ID.
  case quote(String)

  /// The path for a specific author, identified by ID.
  case author(String)

  /// The path for an author's profile image, identified by size and slug.
  case authorProfile(Int, String)

  /// The path for the search quotes endpoint.
  case searchQuotes

  /// The path for the search authors endpoint.
  case searchAuthors

  /// A string representation of the path.
  public var description: String {
    switch self {
    case .quotes: return "quotes"
    case .randomQuote: return "quotes/random"
    case .authors: return "authors"
    case .tags: return "tags"
    case .quote(let id): return "quotes/\(id)"
    case .author(let id): return "authors/\(id)"
    case .authorProfile(let size, let slug): return "profile/\(size)/\(slug).jpg"
    case .searchQuotes: return "search/quotes"
    case .searchAuthors: return "search/authors"
    }
  }
}
