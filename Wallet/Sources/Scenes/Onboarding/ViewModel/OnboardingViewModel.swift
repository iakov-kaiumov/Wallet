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
    
    var showProgressView: ((_ isOn: Bool) -> Void)?
    
    private let dependencies: Dependencies
    
    // MARK: - Init
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Public Methods
    func loginButtonDidTap(presenting controller: UIViewController) {
        dependencies.signInService.signIn(presenting: controller) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.delegate?.onboardingViewModelSuccessfulSignIn()
                case .failure(let error):
                    print(error)
                }
                self?.showProgressView?(false)
            }
        }
    }
}
