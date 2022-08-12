//
//  CurrenciesViewController.swift
//  Wallet
//

import Foundation
import UIKit
import SnapKit

final class CurrenciesViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CurrenciesViewModel
    private let closeButton = UIButton(type: .system)
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
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupCloseButton()
        setupTableView()
        
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
        viewModel.loadTestData()
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
        }
        
        closeButton.setTitle(R.string.localizable.modal_close_button(), for: .normal)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(closeButton.snp.bottom).offset(16)
        }
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.identifier, for: indexPath)
            let type = viewModel.currencies[indexPath.row]
            
            if let cell = cell as? CurrencyCell {
                cell.configure(type: type)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreCell.identifier, for: indexPath)
            
            if let cell = cell as? ShowMoreCell {
                cell.configure(isShortMode: viewModel.isShortMode)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            if let chosenIndex = viewModel.chosenIndex {
                let chosenIndexPath = IndexPath(row: chosenIndex, section: 0)
                tableView.selectRow(at: chosenIndexPath, animated: false, scrollPosition: .none)
            }
            viewModel.toggleState()
        } else {
            viewModel.chosenIndex = indexPath.row
        }
    }
}

extension CurrenciesViewController: UITableViewDelegate {
    
}
