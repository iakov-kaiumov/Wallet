//
//  OnboardingViewModel.swift
//  Wallet
//

import Foundation
import UIKit
import AuthenticationServices

protocol OnboardingViewModelDelegate: AnyObject {
    func onboardingViewModelSuccessfulSignIn()
    
    func onboardingViewModel(_ viewModel: OnboardingViewModel, didReceiveError error: Error)
}

final class OnboardingViewModel: NSObject {
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
    func googleButtonDidTap(presenting controller: UIViewController) {
        dependencies.signInService.signIn(presenting: controller) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.delegate?.onboardingViewModelSuccessfulSignIn()
                case .failure(let error):
                    self.delegate?.onboardingViewModel(self, didReceiveError: error)
                }
                self.showProgressView?(false)
            }
        }
    }
    
    func appleButtonDidTap() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = []
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension OnboardingViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        let idToken = appleIDCredential.user
        
        showProgressView?(true)
        
        dependencies.signInService.signInWithServer(idToken: idToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.delegate?.onboardingViewModelSuccessfulSignIn()
                case .failure(let error):
                    print(error)
                    self.delegate?.onboardingViewModel(self, didReceiveError: error)
                }
                self.showProgressView?(false)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.onboardingViewModel(self, didReceiveError: error)
    }
}
