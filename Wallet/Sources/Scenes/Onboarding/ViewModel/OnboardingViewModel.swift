//
//  OnboardingViewModel.swift
//  Wallet
//

import Foundation

protocol OnboardingViewModelDelegate: AnyObject {
    func onboardingViewModelDidEnd(_ viewModel: OnboardingViewModel)
}

final class OnboardingViewModel {
    weak var delegate: OnboardingViewModelDelegate?
    
    func loginButtonDidTap() {
        delegate?.onboardingViewModelDidEnd(self)
    }
}
