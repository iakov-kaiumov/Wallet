//
//  NetworkService.swift
//  Wallet
//

import Foundation

class NetworkService {
    static func makeGetRequest(_ urlString: String, token: String) -> NSMutableURLRequest? {
        guard let url = URL(string: urlString.encodeUrl) else { return nil }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func makePostRequest(_ urlString: String, token: String) -> NSMutableURLRequest? {
        guard let url = URL(string: urlString.encodeUrl) else { return nil }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func fetchModel<T: Decodable>(
        _ type: T.Type,
        request: URLRequest,
        completion: @escaping (_ result: Result<T, NetworkError>) -> ()
    ) {
        fetchData(type, request: request) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func fetchData<T: Decodable>(
        _ type: T.Type,
        request: URLRequest,
        completion: @escaping (_ result: Result<Data, NetworkError>) -> ()
    ) {
        URLSession(configuration: .ephemeral).dataTask(with: request as URLRequest) { data, response, error in
            
            if let networkError = NetworkError(data: data, response: response, error: error) {
                completion(.failure(networkError))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
