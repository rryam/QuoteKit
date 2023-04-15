//
//  QuotableEndpoint.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

/// A struct that represents an endpoint for the Quotable API.
///
/// Use this struct to create a URL for a specific endpoint on the Quotable API.
///
/// Example usage:
///
/// ```
/// let endpoint = QuotableEndpoint(.random)
/// let url = endpoint.url
/// ```
public struct QuotableEndpoint {

  /// The path component of the endpoint.
  var path: QuotableEndpointPath

  /// The query items to include in the URL, if any.
  var queryItems: [URLQueryItem]?

  /// The host to use for the URL.
  var host: QuotableURLHost

  /// Initializes a new `QuotableEndpoint` instance with the given properties.
  ///
  /// - Parameters:
  ///   - path: The path component of the endpoint.
  ///   - queryItems: The query items to include in the URL, if any.
  ///   - host: The host to use for the URL.
  public init(_ path: QuotableEndpointPath, queryItems: [URLQueryItem]? = nil, host: QuotableURLHost = .production) {
    self.path = path
    self.queryItems = queryItems
    self.host = host
  }
}

extension QuotableEndpoint {

  /// The URL for the endpoint.
  var url: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host.rawValue
    components.path = "/" + path.description

    if let queryItems = queryItems, !queryItems.isEmpty {
      components.queryItems = queryItems
    }

    guard let url = components.url else {
      preconditionFailure("Invalid URL components: \(components)")
    }

    return url
  }
}

