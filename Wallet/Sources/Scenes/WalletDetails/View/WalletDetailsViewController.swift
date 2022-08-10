//
//  WalletDetailsViewController.swift
//  Wallet
//

import UIKit
import Rswift

final class WalletDetailesViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: WalletDetailesViewModel
    
    private let settingsButton = UIButton(type: .system)
    private let walletName = UILabel()
    private let walletAmount = UILabel()
    
    // MARK: - Init
    init(viewModel: WalletDetailesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = R.color.background()
        
    }
}
