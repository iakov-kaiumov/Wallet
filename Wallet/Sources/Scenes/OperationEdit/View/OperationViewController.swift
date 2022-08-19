//
//  OperationViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class OperationViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: OperationViewModel

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
    
    private lazy var datePicker: PopupDatePicker = PopupDatePicker()
    
    private lazy var progressView = ProgressView()

    private lazy var nextButton: UIButton = ButtonFactory.makeGrayButton()

    // MARK: - Init
    init(viewModel: OperationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.setButtonInteraction = setButtonEnabled
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Actions
    @objc private func nextButtonAction() {
        viewModel.nextButtonDidTap()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        if viewModel.isCreatingMode {
            title = R.string.localizable.operation_edit_add_title()
        } else {
            title = R.string.localizable.operation_edit_edit_title()
        }

        setupTableView()
        setupNextButton()
        setupDatePicker()
        setupProgressView()
        
        viewModel.showProgressView = { isOn in
            if isOn {
                self.progressView.show()
            } else {
                self.progressView.hide()
            }
        }

        viewModel.onItemChanged = { [weak self] _ in
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

        setButtonEnabled(false)
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }

        let title = viewModel.isCreatingMode ? R.string.localizable.operation_edit_add_button() : R.string.localizable.operation_edit_edit_title()
        nextButton.setTitle(title, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    private func setupDatePicker() {
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        datePicker.alpha = 0.0
        
        datePicker.onDismissed = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.toggleDatePicker(enabled: false)
        }
        
        datePicker.onValueChanged = { [weak self] date in
            guard let self = self else {
                return
            }
            self.viewModel.changeDate(date)
        }
    }
    
    private func toggleDatePicker(enabled: Bool) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            options: [.curveEaseInOut, .transitionCrossDissolve],
            animations: {
                self.datePicker.alpha = enabled ? 1.0 : 0.0
            },
            completion: nil
        )
    }
    
    private func setButtonEnabled(_ isActive: Bool) {
        nextButton.isEnabled = isActive
        nextButton.backgroundColor = isActive ? R.color.loginButton() : R.color.warningGrey()
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension OperationViewController: UITableViewDataSource {

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
            cell.configure(with: DefaultEditCellConfiguration(title: model.title, subtitle: model.value))
        }
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = viewModel.tableItems[indexPath.row]
        if model.type == .date {
            toggleDatePicker(enabled: true)
        } else {
            viewModel.cellDidTap(item: model)
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension OperationViewController: UITableViewDelegate {

}
