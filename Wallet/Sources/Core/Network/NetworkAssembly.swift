//
//  NetworkAssembly.swift
//  Wallet
//

import Foundation

final class NetworkAssembly {
    private(set) lazy var requestProcessor: IRequestProcessor = RequestProcessor(session: .shared, requestConstructor: RequestConstructor())
}
