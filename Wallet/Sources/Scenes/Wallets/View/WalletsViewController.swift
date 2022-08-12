//
//  WalletsViewController.swift
//  Wallet

import UIKit
import SnapKit

class WalletsViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: WalletsViewModel
    lazy var headerView = HeaderView()
    lazy var currenciesView = CurrenciesView()
    lazy var createWalletButton = ButtonFactory.makeGrayButton()
    lazy var emptyLabel = UILabel()
    lazy var walletsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
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
        setupEmptyLabel()
    }
    
    // MARK: - private methods
    func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        headerView.setData(balance: 23.45, income: 12, expences: nil)
    }
    
    func setupCurrenciesView() {
        view.addSubview(currenciesView)
        currenciesView.translatesAutoresizingMaskIntoConstraints = false
        currenciesView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(headerView.snp.bottom).offset(16)
        }
    }
    
    func setupCreateWalletButton() {
        createWalletButton.setTitle(R.string.localizable.wallets_button(), for: .normal)
        
        view.addSubview(createWalletButton)
        createWalletButton.translatesAutoresizingMaskIntoConstraints = false
        createWalletButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    func setupWalletsTableView() {
        view.addSubview(walletsTableView)
        walletsTableView.translatesAutoresizingMaskIntoConstraints = false
        walletsTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(currenciesView.snp.bottom).offset(25)
        }
    }
    
    func setupEmptyLabel() {
        emptyLabel.text = R.string.localizable.wallets_empty_label()
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyLabel.textColor = .systemGray
        emptyLabel.numberOfLines = 2
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
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
        emptyLabel.layer.opacity = viewModel.wallets.isEmpty ? 1.0 : 0.0
        return viewModel.wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.reuseIdentifier, for: indexPath) as? WalletCell
        
        cell?.configure(model: viewModel.wallets[indexPath.row])
        
        return cell ?? WalletCell()
    }
}
