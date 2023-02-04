//
//  QuoteKit.swift
//  QuoteKit
//
//  Created by Rudrank Riyam on 28/08/21.
//

import Foundation

public struct QuoteKit {
  static internal func execute<Model: Decodable>(with endpoint: QuotableEndpoint) async throws -> Model {
    let (data, _) = try await URLSession.shared.data(from: endpoint.url)
    return try JSONDecoder().decode(Model.self, from: data)
  }

  static internal func execute<Model: Decodable>(with endpoint: QuotableEndpoint, completion: @escaping (Result<Model, Error>) -> ()) {
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
