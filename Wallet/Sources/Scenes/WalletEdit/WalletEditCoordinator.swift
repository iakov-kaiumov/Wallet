//
//  WalletEditCoordinator.swift
//  Wallet
//

import UIKit

final class WalletEditCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    var viewModel: WalletEditViewModel?
    var nameInputViewModel: TextInputViewModel?
    var currenciesViewModel: CurrenciesViewModel?
    var limitInputViewModel: TextInputViewModel?
    
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        configure()
        if let viewModel = viewModel {
            let controller = WalletEditViewController(viewModel: viewModel)
            navigationController.setViewControllers([controller], animated: false)
        }
    }
    
    private func configure() {
        viewModel = WalletEditViewModel()
        viewModel?.delegate = self
        
        nameInputViewModel = TextInputViewModel.makeWalletName(isModal: true)
        nameInputViewModel?.delegate = self
        
        currenciesViewModel = CurrenciesViewModel()
        currenciesViewModel?.delegate = self
        
        limitInputViewModel = TextInputViewModel.makeWalletLimit(isModal: true)
        limitInputViewModel?.delegate = self
    }
}

extension WalletEditCoordinator: WalletEditViewModelDelegate {
    
    func walletEditViewModelEnterName(_ currentValue: String?) {
        guard let nameInputViewModel = nameInputViewModel else { return }
        nameInputViewModel.text = currentValue
        let controller = TextInputViewController(viewModel: nameInputViewModel)
        navigationController.present(controller, animated: true)
    }
    
    func walletEditViewModelEnterCurrency(_ currentValue: String?) {
        guard let currenciesViewModel = currenciesViewModel else { return }
        if let currentValue = currentValue,
           let type = CurrencyType(rawValue: currentValue) {
            currenciesViewModel.setCurrentCurrency(type)
        }
        let controller = CurrenciesViewController(viewModel: currenciesViewModel)
        navigationController.present(controller, animated: true)
    }
    
    func walletEditViewModelEnterLimit(_ currentValue: String?) {
        guard let limitInputViewModel = limitInputViewModel else { return }
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
            viewModel?.changeName(value)
        case .walletLimit:
            viewModel?.changeLimit(value)
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
        viewModel?.changeCurrency(value)
    }
}
