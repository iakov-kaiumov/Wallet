//
//  RequestProcessor.swift
//  Wallet
//

import Foundation

protocol IRequestProcessor: AnyObject {
    func fetch<T: IRequest>(_ request: T, completion: @escaping (Result<T.Model, NetworkError>) -> Void)
}

final class RequestProcessor: IRequestProcessor {
    private let session: URLSession
    private let requestConstructor: IRequestConstructor
    private let decoder: JSONDecoder
    
    init(
        session: URLSession,
        requestConstructor: IRequestConstructor,
        decoder: JSONDecoder = .init()
    ) {
        self.session = session
        self.requestConstructor = requestConstructor
        self.decoder = decoder
    }
    
    func fetch<T: IRequest>(_ request: T, completion: @escaping (Result<T.Model, NetworkError>) -> Void) {
        guard let urlRequest = try? requestConstructor.construct(from: request) else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let networkError = NetworkError(data: data, response: response, error: error) {
                completion(.failure(networkError))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let json = try self.decoder.decode(T.Model.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
    }
}