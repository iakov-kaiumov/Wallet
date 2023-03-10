//
//  CurrenciesViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class CurrenciesViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CurrenciesViewModel
    
    private lazy var nextButton: UIButton = ButtonFactory.makeGrayButton()
    private lazy var closeButton = UIButton(type: .system)
    private lazy var progressView = ProgressView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.identifier)
        tableView.register(ShowMoreCell.self, forCellReuseIdentifier: ShowMoreCell.identifier)
        
        return tableView
    }()
    
    // MARK: - Init
    init(viewModel: CurrenciesViewModel) {
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
    
    // MARK: - Actions
    @objc private func closeButtonAction(sender: UIButton!) {
        viewModel.closeButtonDidTap()
    }
    
    @objc private func nextButtonAction(sender: UIButton!) {
        viewModel.nextButtonDidTap()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupCloseButton()
        setupTableView()
        setupNextButton()
        setupProgressView()
        
        viewModel.onDataInserted = { [weak self] (at: [IndexPath]) -> Void in
            guard let self = self else { return }
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: at, with: .top)
            
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            self.tableView.endUpdates()
            
        }
        viewModel.onDataDeleted = { [weak self] (at: [IndexPath]) -> Void in
            guard let self = self else { return }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: at, with: .top)
            
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            self.tableView.endUpdates()
        }
        
        viewModel.onDataReload = { [weak self] in
            self?.tableView.reloadData()
            self?.progressView.hide()
        }
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        closeButton.setTitle(R.string.localizable.modal_close_button(), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        progressView.show()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(closeButton.snp.bottom).offset(16)
        }
    }
    
    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        nextButton.setTitle(R.string.localizable.default_save_button(), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
}

extension CurrenciesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.currencies.count
        }
        return viewModel.currencies.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.identifier, for: indexPath)
            let model = viewModel.currencies[indexPath.row]
            
            if let cell = cell as? CurrencyCell {
                cell.configure(title: model.fullDescription)
                cell.accessoryType = model.code == viewModel.currencyModel.code ? .checkmark : .none
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreCell.identifier, for: indexPath)
            
            if let cell = cell as? ShowMoreCell {
                cell.configure(viewModel.getShowMoreCellModel())
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            viewModel.toggleState()
            return
        }
        
        let model = viewModel.currencies[indexPath.row]
        
        if let oldIndex = viewModel.currencies.firstIndex(where: { $0.code == viewModel.currencyModel.code }) {
            let oldPath = IndexPath(row: oldIndex, section: 0)
            tableView.cellForRow(at: oldPath)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        viewModel.currencyModel = model
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension CurrenciesViewController: UITableViewDelegate {
    
}
