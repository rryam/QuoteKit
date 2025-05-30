//
//  QuotableURLHost.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 29/08/21.
//

import Foundation

/// Learnt this way of creating a URLHost from this article - https://www.swiftbysundell.com/articles/testing-networking-logic-in-swift/

struct QuotableURLHost: RawRepresentable {
  var rawValue: String
}

extension QuotableURLHost {
  static var staging: Self {
    QuotableURLHost(rawValue: "staging.quotable.io")
  }

  static var images: Self {
    QuotableURLHost(rawValue: "images.quotable.dev")
  }

  static var production: Self {
    QuotableURLHost(rawValue: "api.quotable.io")
  }

  /// Backup API host that works when the primary APIs have SSL certificate issues
  static var backup: Self {
    QuotableURLHost(rawValue: "api.quotable.kurokeita.dev")
  }

  static var `default`: Self {
    // Check environment variable to use backup API
    if ProcessInfo.processInfo.environment["QUOTEKIT_USE_BACKUP"] == "1" {
      return backup
    }

    #if DEBUG
      return staging
    #else
      return production
    #endif
  }
}
