//
//  WalletEditCoordinator.swift
//  Wallet
//

import UIKit

protocol WalletEditCoordinatorDelegate: AnyObject {
    func updateWallets()
}

final class WalletEditCoordinator: Coordinator {
    weak var parent: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var dependencies: AppDependency
    
    private var walletViewModel: WalletEditViewModel
    
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
                walletViewModel.isCreatingMode = isCreatingMode
            }
            start()
        }
    }
}

extension WalletEditCoordinator: WalletEditViewModelDelegate {
    func walletsViewModel(_ viewModel: WalletEditViewModel, didReceiveError error: Error) {
        callBanner(type: .unknownError)
    }
    
    func walletEditViewModelDidFinish(walletID: Int) {
        if walletViewModel.isCreatingMode {
            navigationController.popToRootViewController(animated: true)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
    
    func walletEditViewModelEnterName(_ currentValue: String?) {
        let nameInputViewModel = TextInputViewModel.makeWalletName(isModal: true)
        nameInputViewModel.delegate = self
        nameInputViewModel.text = currentValue
        
        let controller = TextInputViewController(viewModel: nameInputViewModel)
        navigationController.present(controller, animated: true)
    }
    
    func walletEditViewModelEnterCurrency(_ currentValue: CurrencyModel) {
        let currenciesViewModel = CurrenciesViewModel(dependencies: dependencies, currencyModel: currentValue)
        currenciesViewModel.delegate = self
        
        let controller = CurrenciesViewController(viewModel: currenciesViewModel)
        navigationController.present(controller, animated: true)
    }
    
    func walletEditViewModelEnterLimit(_ currentValue: Decimal?) {
        let limitInputViewModel = TextInputViewModel.makeWalletLimit(isModal: true)
        limitInputViewModel.delegate = self
        limitInputViewModel.text = currentValue?.displayString() ?? ""
        
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
        case .walletNameIntermediate:
            walletViewModel.changeName(value)
            self.start()
        case .walletLimit:
            walletViewModel.changeLimit(value?.toDecimal)
        default:
            break
        }
        navigationController.dismiss(animated: true)
    }
}

extension WalletEditCoordinator: CurrenciesViewModelDelegate {
    func currenciesViewModel(_ viewModel: CurrenciesViewModel, didReceiveError error: Error) {
        callBanner(type: .unknownError)
    }
    
    func currenciesViewModelCloseButtonDidTap() {
        navigationController.dismiss(animated: true)
    }
    
    func currenciesViewModelValueChanged(_ value: CurrencyModel) {
        walletViewModel.changeCurrency(value)
        navigationController.dismiss(animated: true)
    }
}
