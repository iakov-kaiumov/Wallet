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
    
    private var errorViewCenter: CGPoint = CGPoint()
    private let errorViewHidingThreshold: CGFloat = 20
    
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
        view.backgroundColor = R.color.background()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    // MARK: - Actions
    @objc private func createWalletButtonAction() {
        viewModel.createWalletButtonDidTap()
    }
    
    @objc private func signOutButtonTapped() {
        viewModel.signOut()
    }
    
    @objc private func panGestureAction(_ gesture: UIPanGestureRecognizer) {
        guard let errorView = gesture.view else { return }
        let point = gesture.translation(in: view)
        
        if gesture.state == .began {
            errorViewCenter = errorView.center
        }
        if gesture.state != .cancelled {
            let alpha = max(0, 0.5 - abs(errorView.center.y - errorViewCenter.y) / view.bounds.height * 4)
            errorView.center = CGPoint(x: errorView.center.x, y: errorView.center.y + point.y * alpha)
            gesture.setTranslation(CGPoint.zero, in: view)
        }
        
        if gesture.state == .cancelled || gesture.state == .ended {
            if (errorViewCenter.y - errorView.center.y) > errorViewHidingThreshold {
                hideErrorPopup(errorView)
            } else {
                resetErrorPopup(errorView)
            }
        }
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
        signOutButton.tintColor = .systemBackground
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
    
    private func showErrorPopup() {
        let errorPopup = ErrorPopup(message: "Что-то пошло не так")
        view.addSubview(errorPopup)
        errorPopup.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(0)
            $0.height.equalTo(56)
        }
        errorPopup.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureAction)))
    }
    
    private func hideErrorPopup(_ errorView: UIView) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveLinear],
            animations: {
                errorView.center.y -= 200
            },
            completion: { _ in
                errorView.removeFromSuperview()
            }
        )
    }
    
    private func resetErrorPopup(_ errorView: UIView) {
        UIView.animate(
            withDuration: 0.33,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self = self else { return }
                errorView.center = self.errorViewCenter
            },
            completion: nil
        )
    }
}

// MARK: - Extensions
extension WalletsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectWalletWithIndex(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.onCellTapped(indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Hide/show action
        let hide = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completionHandler) in
            self?.viewModel.onCellHide(indexPath)
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
