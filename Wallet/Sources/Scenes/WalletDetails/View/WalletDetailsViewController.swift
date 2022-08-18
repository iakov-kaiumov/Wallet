//
//  WalletDetailsViewController.swift
//  Wallet
//

import UIKit
import Rswift

final class WalletDetailesViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: WalletDetailesViewModel
    
    private lazy var settingsButton = UIBarButtonItem()
    private lazy var tableHeaderView = OperationTableHeaderView()
    private lazy var operationTableView = UITableView()
    private lazy var emptyLabel = UILabel()
    private lazy var addOperationButton = ButtonFactory.makeGrayButton()
    private lazy var blurView = UIView()
    private var isBlurApplied = false
    
    private var lastHeaderViewY: CGFloat = 0
    
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
        viewModel.onDidUpdateWalletInfo = { [weak self] in
            guard let model = self?.viewModel.walletInfoModel else { return }
            self?.tableHeaderView.configure(with: model)
        }
        viewModel.onDidUpdateOperations = { [weak self] in
            self?.operationTableView.reloadData()
        }
        viewModel.onDidDeleteOperaion = { [weak self] indexPath in
            self?.operationTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        viewModel.onDidDeleteSection = { [weak self] section in
            self?.operationTableView.beginUpdates()
            self?.operationTableView.deleteRows(at: [IndexPath(row: 0, section: section)], with: .fade)
            self?.operationTableView.deleteSections(IndexSet(integer: section), with: .fade)
            self?.operationTableView.endUpdates()
        }
        viewModel.load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isBlurApplied {
            blurView.applyBlur()
            isBlurApplied = true
        }
        
        if let headerView = operationTableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + 8
            var headerFrame = headerView.frame

            // Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                operationTableView.tableHeaderView = headerView
            }
            operationTableView.scrollIndicatorInsets = UIEdgeInsets(
                top: height + 16, left: 0, bottom: 0, right: 0
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Actions
    @objc private func settingsButtonTapped() {
        viewModel.settingButtonDidTap()
    }
    
    @objc private func addOperationButtonTapped() {
        viewModel.addOperationButtonDidTap()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = R.color.background()
        title = ""
        
        setupSettingsButton()
        setupOperationTableView()
        setupEmptyLabel()
        setupAddOperationButton()
    }
    
    private func setupSettingsButton() {
        settingsButton.image = R.image.settingsButton()
        settingsButton.style = .plain
        settingsButton.target = self
        settingsButton.action = #selector(settingsButtonTapped)
        settingsButton.tintColor = R.color.accentPurple()
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupOperationTableView() {
        view.addSubview(operationTableView)
        operationTableView.register(OperationCellView.self,
                                    forCellReuseIdentifier: OperationCellView.uniqueIdentifier)
        operationTableView.delegate = self
        operationTableView.dataSource = self
        operationTableView.separatorStyle = .none
        operationTableView.tableHeaderView = tableHeaderView
        operationTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        operationTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
        }
        
        emptyLabel.text = R.string.localizable.operations_empty_label()
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyLabel.textColor = .systemGray
        emptyLabel.numberOfLines = 2
    }
    
    private func setupAddOperationButton() {
        view.addSubview(addOperationButton)
        
        view.addSubview(blurView)
        blurView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(addOperationButton.snp.top).offset(-16)
        }
        
        addOperationButton.setTitle(R.string.localizable.operations_create_button(), for: .normal)
        addOperationButton.addTarget(self, action: #selector(addOperationButtonTapped), for: .touchUpInside)
        addOperationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        view.bringSubviewToFront(addOperationButton)
    }
    
    private func setNavigationTitle() {
        guard let walletName = viewModel.walletInfoModel?.walletName,
              let walletAmount = viewModel.walletInfoModel?.walletAmount else { return }
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = .fade
            
        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = walletName + " – " + walletAmount
    }
    
    private func removeNavigationTitle() {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = .fade
            
        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = ""
    }
    
}

// MARK: - UITableViewDelegate
extension WalletDetailesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = viewModel.operationSections[section].sectionName
        let container = UIView()
        container.backgroundColor = .systemBackground.withAlphaComponent(0.85)
        container.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        return container
    }

}

// MARK: - UITableViewDataSource
extension WalletDetailesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        emptyLabel.layer.opacity = viewModel.operationSections.isEmpty ? 1.0 : 0.0
        tableView.isScrollEnabled = !viewModel.operationSections.isEmpty
        return viewModel.operationSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.operationSections[section].operationModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OperationCellView.uniqueIdentifier,
                                                 for: indexPath)
        if let cell = cell as? OperationCellView {
            let model = viewModel.operationSections[indexPath.section].operationModels[indexPath.row]
            
            if !model.isSkeleton {
                cell.configure(with: model)
            }
            cell.setupSkeleton(
                insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
                cornerRadius: 16
            )
            cell.showSkeleton(model.isSkeleton)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentHeaderViewY = scrollView.contentOffset.y
        let headerViewHeightNeededForAnimation: CGFloat = 10

        if lastHeaderViewY <= headerViewHeightNeededForAnimation,
           currentHeaderViewY > headerViewHeightNeededForAnimation {
            setNavigationTitle()
        }

        if lastHeaderViewY > headerViewHeightNeededForAnimation,
           currentHeaderViewY <= headerViewHeightNeededForAnimation {
            removeNavigationTitle()
        }

        lastHeaderViewY = currentHeaderViewY
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = UIContextualAction(style: .destructive, title: "") { [weak self] (_, _, completionHandler) in
            self?.viewModel.deleteOperation(at: indexPath)
            completionHandler(true)
        }
        trash.image = R.image.actionDelete()
        trash.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        return configuration
    }
}
