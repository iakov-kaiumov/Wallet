//
//  ProxyService + PersonService.swift
//  Wallet
//

import Foundation

extension ProxyService: PersonServiceProtocol {
    func addDelegate(_ delegate: PersonServiceDelegate) {
        networkService.addDelegate(delegate)
    }
    
    func personServiceGet(completion: @escaping (Result<PersonApiModel, NetworkError>) -> Void) {
        networkService.personServiceGet { [weak self] result in
            completion(result)
            self?.notifyPersonDelegates(result: result)
        }
    }
    
    private func notifyPersonDelegates(result: Result<PersonApiModel, NetworkError>) {
        switch result {
        case .success(let person):
            self.networkService.personDelegates.forEach {
                $0.personService(self, didLoadPersonInfo: person)
            }
        case .failure:
            break
        }
    }
}
