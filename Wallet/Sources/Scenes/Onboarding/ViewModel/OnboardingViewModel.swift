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
        dependencies.signInService.signIn(presenting: controller) { [weak self] success in
            if success {
                self?.delegate?.onboardingViewModelSuccessfulSignIn()
            } else {
                
            }
        }
    }
}
