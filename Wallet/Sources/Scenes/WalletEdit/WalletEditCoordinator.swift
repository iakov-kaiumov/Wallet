//
//  WalletEditCoordinator.swift
//  Wallet
//

import UIKit

final class WalletEditCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    private var walletViewModel: WalletEditViewModel = WalletEditViewModel()
    
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        walletViewModel.delegate = self
        
        let controller = WalletEditViewController(viewModel: walletViewModel)
        navigationController.setViewControllers([controller], animated: false)
    }
}

extension WalletEditCoordinator: WalletEditViewModelDelegate {
    func walletEditViewModelDidFinish() {
        
    }
    
    func walletEditViewModelEnterName(_ currentValue: String?) {
        let nameInputViewModel = TextInputViewModel.makeWalletName(isModal: true)
        nameInputViewModel.delegate = self
        nameInputViewModel.text = currentValue
        
        let controller = TextInputViewController(viewModel: nameInputViewModel)
        navigationController.present(controller, animated: true)
    }
    
    func walletEditViewModelEnterCurrency(_ currentValue: String?) {
        let currenciesViewModel = CurrenciesViewModel()
        currenciesViewModel.delegate = self
        if let currentValue = currentValue, let type = CurrencyType(rawValue: currentValue) {
            currenciesViewModel.setCurrentCurrency(type)
        }
        
        let controller = CurrenciesViewController(viewModel: currenciesViewModel)
        navigationController.present(controller, animated: true)
    }
    
    func walletEditViewModelEnterLimit(_ currentValue: String?) {
        let limitInputViewModel = TextInputViewModel.makeWalletLimit(isModal: true)
        limitInputViewModel.delegate = self
        limitInputViewModel.text = currentValue
        
        let controller = TextInputViewController(viewModel: limitInputViewModel)
        navigationController.present(controller, animated: true)
    }
}

extension WalletEditCoordinator: TextInputViewModelDelegate {
    func textInputViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func textInputViewModelValueChanged(screen: TextInputScreenType, value: String?) {
        switch screen {
        case .walletName:
            walletViewModel.changeName(value)
        case .walletLimit:
            walletViewModel.changeLimit(value)
        default:
            break
        }
        navigationController.dismiss(animated: true)
    }
}

extension WalletEditCoordinator: CurrenciesViewModelDelegate {
    func currenciesViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func currenciesViewModelValueChanged(_ value: CurrencyType?) {
        walletViewModel.changeCurrency(value)
    }
}
