//
//  WalletsViewController.swift
//  Wallet

import UIKit
import SnapKit

final class WalletsViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: WalletsViewModel
    private lazy var headerView = HeaderView()
    private lazy var currenciesView = CurrenciesView()
    private lazy var createWalletButton = ButtonFactory.makeGrayButton()
    private lazy var emptyLabel = UILabel()
    private lazy var signOutButton = UIBarButtonItem()
    private lazy var walletsTableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: - Init
    init(viewModel: WalletsViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Actions
    @objc private func createWalletButtonAction() {
        viewModel.createWalletButtonDidTap()
    }
    
    @objc private func signOutButtonTapped() {
        viewModel.signOut()
    }
    
    private func showDeleteAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: R.string.localizable.wallets_delete_alert(),
            message: "",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: R.string.localizable.alert_delete_button(), style: .destructive) { [weak self] _ in
            self?.viewModel.onCellDelete(indexPath)
        }
        let cancelAction = UIAlertAction(title: R.string.localizable.alert_cancel_button(), style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setup() {
        title = ""
        viewModel.onHide = deleteAllHiddenWallets
        viewModel.onShow = insertAllHiddenWallets
        view.backgroundColor = R.color.background()
        
        setupSignOutButton()
        setupHeaderView()
        setupTableView()
        setupCurrenciesView()
        setupWalletsTableView()
        setupCreateWalletButton()
        setupEmptyLabel()
    }
    
    private func setupSignOutButton() {
        signOutButton.title = R.string.localizable.onboarding_logout_button()
        signOutButton.style = .plain
        signOutButton.target = self
        signOutButton.action = #selector(signOutButtonTapped)
        signOutButton.tintColor = .white
        navigationItem.rightBarButtonItem = signOutButton
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
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
        walletsTableView.register(ShowMoreCell.self, forCellReuseIdentifier: ShowMoreCell.identifier)
    }
    
    private func setupCurrenciesView() {
        view.addSubview(currenciesView)
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
        createWalletButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        createWalletButton.addTarget(self, action: #selector(createWalletButtonAction), for: .touchUpInside)
    }
    
    private func setupWalletsTableView() {
        view.addSubview(walletsTableView)
        walletsTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(currenciesView.snp.bottom).offset(25)
        }
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
        }
        
        emptyLabel.text = R.string.localizable.wallets_empty_label()
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyLabel.textColor = .systemGray
        emptyLabel.numberOfLines = 2
    }
    
    private func deleteAllHiddenWallets() {
        let section = 2
        let count = walletsTableView.numberOfRows(inSection: section)
        let indexPaths = (0..<count).map { IndexPath(row: $0, section: section) }
        walletsTableView.deleteRows(at: indexPaths, with: .fade)
        walletsTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
    }
    
    private func insertAllHiddenWallets() {
        let section = 2
        let count = viewModel.hiddenWallets.count
        let indexPaths = (0..<count).map { IndexPath(row: $0, section: section) }
        walletsTableView.insertRows(at: indexPaths, with: .fade)
        walletsTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
    }
}

// MARK: - Extensions
extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 60
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 1 {
            viewModel.selectWalletWithIndex(indexPath.row, section: indexPath.section)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.onCellTapped(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            return nil
        }
        
        // Hide/show action
        let hide = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completionHandler) in
            self?.viewModel.onCellHide(indexPath)
            
            if let vc = self {
                if vc.viewModel.isHidden {
                    vc.walletsTableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    var section: Int
                    if indexPath.section == 0 {
                        section = 2
                    } else {
                        section = 0
                    }
                    let row = vc.walletsTableView.numberOfRows(inSection: section)
                    vc.walletsTableView.moveRow(at: indexPath, to: IndexPath(row: row, section: section))
                }
            }
            completionHandler(true)
        }
        hide.image = R.image.actionHide()
        hide.backgroundColor = .systemBackground
        
        // Edit action
        let edit = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completionHandler) in
            self?.viewModel.onCellEdit(indexPath)
            completionHandler(true)
        }
        edit.image = R.image.actionEdit()
        edit.backgroundColor = .systemBackground
        
        // Trash action
        let trash = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, completionHandler) in
            self?.showDeleteAlert(for: indexPath)
            completionHandler(true)
        }
        trash.image = R.image.actionDelete()
        trash.backgroundColor = .systemBackground
        
        let configuration = UISwipeActionsConfiguration(actions: [trash, edit, hide])
        
        return configuration
    }
}

extension WalletsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyLabel.layer.opacity = viewModel.shownWallets.isEmpty && viewModel.hiddenWallets.isEmpty ? 1.0 : 0.0
        switch section {
        case 0:
            return viewModel.shownWallets.count
        case 1:
            return viewModel.haveHiddenWallets() ? 1 : 0
        case 2:
            return viewModel.hiddenWallets.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.reuseIdentifier, for: indexPath)
            
            if let cell = cell as? WalletCell {
                cell.configure(model: viewModel.shownWallets[indexPath.row])
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreCell.identifier, for: indexPath)
            
            if let cell = cell as? ShowMoreCell {
                cell.configure(viewModel.makeShowMoreCellModel())
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.reuseIdentifier, for: indexPath)
            
            if let cell = cell as? WalletCell {
                cell.configure(model: viewModel.hiddenWallets[indexPath.row])
            }
            
            return cell
        }

    }
}
