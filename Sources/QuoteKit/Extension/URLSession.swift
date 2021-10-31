//
//  URLSession.swift
//  
//
//  Created by Rudrank Riyam on 31/10/21.
//

import Foundation

// Taken from Swift by Sundell -
// (Making async system APIs backward compatible)[https://www.swiftbysundell.com/articles/making-async-system-apis-backward-compatible/]
@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
                
                guard let response = response else {
                    return continuation.resume(throwing: URLError(.badServerResponse))
                }
                
                guard let data = data else {
                    return continuation.resume(throwing: QuoteFetchError.missingData)
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
}
