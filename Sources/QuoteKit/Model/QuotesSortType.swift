//
//  QuotesSortType.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 30/08/21.
//

import Foundation

/// An enum that represents the sort type for a collection of quotes.
///
/// Use this enum to specify how a collection of quotes should be sorted.
///
/// Example usage:
///
///     let sortType: QuotesSortType = .author
public enum QuotesSortType: String, Sendable {

  /// Sort by the date the quote was added.
  case dateAdded

  /// Sort by the date the quote was last modified.
  case dateModified

  /// Sort by the author of the quote.
  case author

  /// Sort by the content of the quote.
  case content
}
