//
//  ExampleService.swift
//  Wallet
//

import Foundation

protocol IExampleService: AnyObject {
    func loadItems(page: UInt, count: UInt, completion: @escaping (Result<ExampleResult, NetworkError>) -> Void)
}

final class ExampleService: IExampleService {
    
    private let requestProcessor: IRequestProcessor
    
    init(requestProcessor: IRequestProcessor) {
        self.requestProcessor = requestProcessor
    }
    
    // MARK: - IQuestionsService
    
    func loadItems(page: UInt, count: UInt, completion: @escaping (Result<ExampleResult, NetworkError>) -> Void) {
        let request = ExampleRequest(page: page, count: count)
        requestProcessor.fetch(request) { result in
            completion(result)
        }
    }
}
