//
//  OnboardingViewModel.swift
//  Wallet
//

import Foundation
import UIKit

protocol OnboardingViewModelDelegate: AnyObject {
    func onboardingViewModelSuccessfulSignIn()
}

final class OnboardingViewModel {
    // MARK: - Properties
    typealias Dependencies = HasSignInService
    
    weak var delegate: OnboardingViewModelDelegate?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func loginButtonDidTap(presenting controller: UIViewController) {
        dependencies.signInService.signIn(presenting: controller) { [weak self] result in
            switch result {
            case .success(let email):
                print("PUPA")
                print(email)
                self?.delegate?.onboardingViewModelSuccessfulSignIn()
            case .failure(let error):
                print(error)
            }
        }
    }
}
