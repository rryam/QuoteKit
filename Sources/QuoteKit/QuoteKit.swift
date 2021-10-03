//
//  QuoteKit.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

enum QuoteFetchError: Error {
    case invalidURL
    case missingData
}

public struct QuoteKit {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static func execute<Model: Decodable>(with endpoint: QuotableEndpoint) async throws -> Model {
        let url = endpoint.url
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Model.self, from: data)
    }
    
    static func execute<Model: Decodable>(with endpoint: QuotableEndpoint, completion: @escaping (Result<Model, Error>) -> ()) {
        let url = endpoint.url
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(QuoteFetchError.missingData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(model))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
    }
}
