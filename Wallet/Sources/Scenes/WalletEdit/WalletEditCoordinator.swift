//
//  WalletEditCoordinator.swift
//  Wallet
//

import UIKit

final class WalletEditCoordinator: Coordinator {
    weak var parent: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    private var walletViewModel: WalletEditViewModel
    
    private var isFirstStart: Bool = true
    
    init(navigationController: UINavigationController,
         dependencies: AppDependency = AppDependency()) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        walletViewModel = WalletEditViewModel(dependencies: dependencies)
    }
    
    func start() {
        walletViewModel.delegate = self
        
        let controller = WalletEditViewController(viewModel: walletViewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func start(isCreatingMode: Bool, wallet: WalletModel? = nil) {
        walletViewModel.isCreatingMode = isCreatingMode
        if isCreatingMode {
            let viewModel = TextInputViewModel.makeWalletName(isModal: false)
            viewModel.delegate = self
            let controller = TextInputViewController(viewModel: viewModel)
            navigationController.pushViewController(controller, animated: true)
        } else {
            if let wallet = wallet {
                walletViewModel = WalletEditViewModel(dependencies: dependencies, wallet: wallet)
            }
            start()
        }
    }
    
    func goToDetails(walletID: Int) {
        // TODO: - Use wallet id
        let coordinator = WalletDetailsCoordinator(navigationController: navigationController, dependencies: dependencies)
        childCoordinators.append(coordinator)
        coordinator.parent = self
        coordinator.start()
    }
}

extension WalletEditCoordinator: WalletEditViewModelDelegate {
    func walletEditViewModelDidFinish(walletID: Int) {
        goToDetails(walletID: walletID)
    }
    
    func walletEditViewModelEnterName(_ currentValue: String?) {
        let nameInputViewModel = TextInputViewModel.makeWalletName(isModal: true)
        nameInputViewModel.delegate = self
        nameInputViewModel.text = currentValue
        
        let controller = TextInputViewController(viewModel: nameInputViewModel)
        navigationController.present(controller, animated: true)
    }
    
    func walletEditViewModelEnterCurrency(_ currentValue: CurrencyModel) {
        let currenciesViewModel = CurrenciesViewModel()
        currenciesViewModel.delegate = self
        currenciesViewModel.setCurrentCurrency(currentValue)
        
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
            
            if walletViewModel.isCreatingMode && isFirstStart {
                isFirstStart = false
                self.start()
            }
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
    
    func currenciesViewModelValueChanged(_ value: CurrencyModel?) {
        walletViewModel.changeCurrency(value)
    }
}
