//
//  WalletsViewController.swift
//  Wallet

import UIKit
import SnapKit

class WalletsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: WalletsViewModel
    private lazy var headerView = HeaderView()
    private lazy var currenciesView = CurrenciesView()
    private lazy var createWalletButton = ButtonFactory.makeGrayButton()
    private lazy var emptyLabel = UILabel()
    private lazy var walletsTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
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

        
    }
    
    // MARK: - private methods
    private func setup() {
        setupHeaderView()
        setupTableView()
        setupCurrenciesView()
        setupWalletsTableView()
        setupCreateWalletButton()
        setupEmptyLabel()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        headerView.configure(model: viewModel.userData)
    }
    
    private func setupTableView() {
        walletsTableView.separatorStyle = .none
        walletsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        walletsTableView.dataSource = self
        walletsTableView.delegate = self
        
        walletsTableView.register(WalletCell.self, forCellReuseIdentifier: WalletCell.reuseIdentifier)
    }
    
    private func setupCurrenciesView() {
        view.addSubview(currenciesView)
        currenciesView.translatesAutoresizingMaskIntoConstraints = false
        currenciesView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(headerView.snp.bottom).offset(16)
        }
        
        currenciesView.configure(model: viewModel.currencyData)
    }
    
    private func setupCreateWalletButton() {
        createWalletButton.setTitle(R.string.localizable.wallets_button(), for: .normal)
        
        view.addSubview(createWalletButton)
        createWalletButton.translatesAutoresizingMaskIntoConstraints = false
        createWalletButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
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
    
    private func setupEmptyLabel() {
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

// MARK: - Extensions
extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension WalletsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyLabel.layer.opacity = viewModel.wallets.isEmpty ? 1.0 : 0.0
        return viewModel.wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? WalletCell {
            cell.configure(model: viewModel.wallets[indexPath.row])
        }
            
        return cell
    }
}
