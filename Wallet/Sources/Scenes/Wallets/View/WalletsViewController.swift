//
//  WalletsViewController.swift
//  Wallet
//
//  Created by Ярослав Ульяненков on 10.08.2022.
//

import UIKit
import SnapKit

class WalletsViewController: UIViewController {
    // MARK: - Properties
    let viewModel: WalletsViewModel
    lazy var headerView = HeaderView()
    lazy var currenciesView = CurrenciesView()
    lazy var createWalletButton = ButtonFactory.makeGrayButton()
    lazy var walletsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(WalletCell.self, forCellReuseIdentifier: WalletCell.reuseIdentifier)
        
        return tableView
    }()
    
    // MARK: - Init
    init(viewModel: WalletsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.background()
        setupHeaderView()
        setupCurrenciesView()
        setupWalletsTableView()
        setupCreateWalletButton()
    }
    
    // MARK: - private methods
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        headerView.setData(balance: 23.45, income: 12, expences: nil)
    }
    
    private func setupCurrenciesView() {
        view.addSubview(currenciesView)
        currenciesView.translatesAutoresizingMaskIntoConstraints = false
        currenciesView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(headerView.snp.bottom).offset(16)
        }
    }
    
    private func setupCreateWalletButton() {
        createWalletButton.setTitle(R.string.localizable.wallets_button(), for: .normal)
        
        view.addSubview(createWalletButton)
        createWalletButton.translatesAutoresizingMaskIntoConstraints = false
        createWalletButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func setupWalletsTableView() {
        view.addSubview(walletsTableView)
        walletsTableView.translatesAutoresizingMaskIntoConstraints = false
        walletsTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(currenciesView.snp.bottom).offset(25)
        }
    }
}

extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension WalletsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.reuseIdentifier, for: indexPath) as? WalletCell
        
        cell?.configure(model: WalletModel.getTestModel())
        
        return cell ?? WalletCell()
    }
}
