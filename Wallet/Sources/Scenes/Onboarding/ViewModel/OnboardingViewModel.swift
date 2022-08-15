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
    private let authUrl: String = ""
    private let callbackUrlScheme: String = ""
    
    weak var delegate: OnboardingViewModelDelegate?
    
    func loginButtonDidTap(presenting controller: UIViewController) {
        SignInService.shared.signIn(presenting: controller) { [weak self] success in
            if success {
                self?.delegate?.onboardingViewModelSuccessfulSignIn()
            } else {
                
            }
        }
    }
}
