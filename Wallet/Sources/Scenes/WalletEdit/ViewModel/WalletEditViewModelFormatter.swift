//
//  WalletEditViewModelFormatter.swift
//  Wallet
//

protocol IWalletEditViewModelFormatter {
    func formatName(_ wallet: WalletModel?) -> String
    func formatCurrency(_ wallet: WalletModel?) -> String
    func formatLimit(_ wallet: WalletModel?) -> String
}

final class WalletEditViewModelFormatter: IWalletEditViewModelFormatter {
    func formatName(_ wallet: WalletModel?) -> String {
        guard let wallet = wallet else {
            return ""
        }
        return wallet.name
    }
    
    func formatCurrency(_ wallet: WalletModel?) -> String {
        guard let wallet = wallet else {
            return ""
        }
        return wallet.currency.shortDescription
    }
    
    func formatLimit(_ wallet: WalletModel?) -> String {
        guard let wallet = wallet, let limit = wallet.limit else {
            return ""
        }
        return limit.displayString(currency: wallet.currency)
    }
}
