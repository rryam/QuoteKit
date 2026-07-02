//
//  QuotableURLHost.swift
//  QuotableURLHost
//
//  Created by Rudrank Riyam on 30/08/21.
//

@testable import QuoteKit
import XCTest

extension QuotableURLHost {
  func expectedURL(with path: String) throws -> URL {
    let apiPath = rawValue == "api.quotable.kurokeita.dev" ? "api/" + path : path
    let encodedPath = apiPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    let url = URL(string: "https://" + rawValue + "/" + encodedPath)
    return try XCTUnwrap(url)
  }
}
