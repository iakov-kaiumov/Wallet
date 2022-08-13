//
//  WalletEditViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class WalletEditViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: WalletEditViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none

        tableView.register(DefaultEditCell.self, forCellReuseIdentifier: DefaultEditCell.identifier)

        return tableView
    }()

    private lazy var nextButton: UIButton = ButtonFactory.makeGrayButton()

    // MARK: - Init
    init(viewModel: WalletEditViewModel) {
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
        view.backgroundColor = .systemBackground
        if viewModel.isCreatingMode {
            navigationController?.navigationBar.topItem?.title = R.string.localizable.wallet_edit_add_title()
        } else {
            navigationController?.navigationBar.topItem?.title = R.string.localizable.wallet_edit_edit_title()
        }

        setupTableView()
        setupNextButton()

        viewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }

    private func setupNextButton() {
        view.addSubview(nextButton)

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }

        let title = viewModel.isCreatingMode ? R.string.localizable.wallet_edit_add_button() : R.string.localizable.wallet_edit_save_button()
        nextButton.setTitle(title, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    @objc private func nextButtonAction() {
        viewModel.nextButtonDidTap()
    }
}

extension WalletEditViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultEditCell.identifier, for: indexPath)
        if let cell = cell as? DefaultEditCell {
            let model = viewModel.tableItems[indexPath.row]
            cell.configure(title: model.title, subtitle: model.value)

            let disabled = !viewModel.isCreatingMode && model.type == .currency
            cell.enabled(!disabled)
        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = viewModel.tableItems[indexPath.row]
        viewModel.cellDidTap(item: model)
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension WalletEditViewController: UITableViewDelegate {

}
