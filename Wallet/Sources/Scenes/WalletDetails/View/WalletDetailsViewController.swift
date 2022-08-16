//
//  WalletDetailsViewController.swift
//  Wallet
//

import UIKit
import Rswift

final class WalletDetailesViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: WalletDetailesViewModel
    
    private let settingsButton = UIBarButtonItem()
    private let walletNameLabel = UILabel()
    private let walletAmountLabel = UILabel()
    private let spendChipsContainerStackView = UIStackView()
    private let incomeChipView = SpendChipView()
    private let expenseChipView = SpendChipView()
    private let operationTableView = UITableView()
    private let addOperationButton = ButtonFactory.makeGrayButton()
    
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
        viewModel.onDidUpdateIncomeChip = { [weak self] in
            guard let model = self?.viewModel.incomeChipModel else { return }
            self?.incomeChipView.configure(with: model)
        }
        viewModel.onDidUpdateExpenseChip = { [weak self] in
            guard let model = self?.viewModel.expenseChipModel else { return }
            self?.expenseChipView.configure(with: model)
        }
        viewModel.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Actions
    @objc private func settingsButtonTapped() {
        print("Tapped")
    }
    
    @objc private func addOperationButtonTapped() {
        viewModel.addOperationButtonDidTap()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = R.color.background()
        title = ""
        setupSettingsButton()
        setupWalletNameLabel()
        setupWalletAmountLabel()
        setupSpendChipsContainerStackView()
        setupOperationTableView()
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
    
    private func setupWalletNameLabel() {
        view.addSubview(walletNameLabel)
        walletNameLabel.text = "Кошелек 1"
        walletNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        walletNameLabel.numberOfLines = 2
        walletNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
        }
    }
    
    private func setupWalletAmountLabel() {
        view.addSubview(walletAmountLabel)
        walletAmountLabel.text = "118 000 ₽"
        walletAmountLabel.font = .systemFont(ofSize: 32, weight: .semibold)
        walletAmountLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(walletNameLabel.snp.bottom).offset(16)
        }
    }
    
    private func setupSpendChipsContainerStackView() {
        view.addSubview(spendChipsContainerStackView)
        spendChipsContainerStackView.axis = .horizontal
        spendChipsContainerStackView.addArrangedSubview(incomeChipView)
        spendChipsContainerStackView.addArrangedSubview(expenseChipView)
        spendChipsContainerStackView.distribution = .fillEqually
        spendChipsContainerStackView.spacing = 16
        spendChipsContainerStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(walletAmountLabel.snp.bottom).offset(16)
        }
    }
    
    private func setupOperationTableView() {
        
    }
    
    private func setupAddOperationButton() {
        view.addSubview(addOperationButton)
        addOperationButton.setTitle("Добавить операцию", for: .normal)
        addOperationButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        addOperationButton.addTarget(self, action: #selector(addOperationButtonTapped), for: .touchUpInside)
    }
    
}
