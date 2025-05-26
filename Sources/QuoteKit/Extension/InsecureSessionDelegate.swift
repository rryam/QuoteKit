//
//  InsecureSessionDelegate.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 26/05/25.
//

import Foundation

/// Custom delegate to bypass SSL validation (for testing only)
/// This delegate disables SSL certificate validation and should NEVER be used in production.
class InsecureSessionDelegate: NSObject, URLSessionDelegate {

  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    // For an insecure session, always trust the server certificate.
    // This is dangerous and should only be used for local testing with known servers.
    guard let serverTrust = challenge.protectionSpace.serverTrust else {
      // If there's no serverTrust, fall back to default handling
      completionHandler(.performDefaultHandling, nil)
      return
    }

    // Create credential from server trust and use it
    let credential = URLCredential(trust: serverTrust)
    completionHandler(.useCredential, credential)
  }
}
