//
//  NetworkServicce.swift
//  TechnicalTaskCrypto
//
//  Created by Александр Кузьминов on 23.01.24.
//
import Foundation

enum APIError: Error {
    case invalidURL
    case decodingError
}
class CryptoService {
    static let shared = CryptoService()
    private init() {}
    
    func fetchData(limit: Int, completion: @escaping (Result<Crypto, Error>) -> Void) {
        guard let url = URL(string: "https://api.coincap.io/v2/assets?limit=\(limit)") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let apiKey = "46ca189b-34b1-43c3-af48-ce34fc35fbdb"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let dataError = NSError(domain: "CryptoService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
                completion(.failure(dataError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let cryptoResponse = try decoder.decode(Crypto.self, from: data)
                completion(.success(cryptoResponse))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }
        task.resume()
    }
}
