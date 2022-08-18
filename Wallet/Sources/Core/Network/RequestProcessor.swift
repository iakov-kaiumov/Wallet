//
//  RequestProcessor.swift
//  Wallet
//

import Foundation

protocol IRequestProcessor: AnyObject {
    func fetchData<T: IRequest>(_ request: T, completion: @escaping (Result<Data, NetworkError>) -> Void)
    
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
    
    func fetchData<T: IRequest>(_ request: T, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let urlRequest = try? requestConstructor.construct(from: request) else {
            completion(.failure(.urlError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let networkError = NetworkError(data: data, response: response, error: error) {
                completion(.failure(networkError))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            task.resume()
//        }
    }
    
    func fetch<T: IRequest>(_ request: T, completion: @escaping (Result<T.Model, NetworkError>) -> Void) {
        fetchData(request) { result in
            switch result {
            case .success(let data):
                do {
                    let json = try self.decoder.decode(T.Model.self, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
