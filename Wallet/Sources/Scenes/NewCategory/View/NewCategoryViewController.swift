//
//  NewCategoryViewController.swift
//  Wallet

import UIKit
import SnapKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: NewCategoryViewModel
    private lazy var tableView: UITableView = UITableView()
    
    // MARK: - Init
    init(viewModel: NewCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.topItem?.title = R.string.localizable.newcategory_title()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(DefaultEditCell.self, forCellReuseIdentifier: DefaultEditCell.identifier)
        tableView.register(IconCell.self, forCellReuseIdentifier: IconCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

// MARK: - UITableViewDataSource
extension NewCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IconCell.identifier, for: indexPath)
            
            if let cell = cell as? IconCell,
               let model = viewModel.tableItems[indexPath.row] as?  NewCategoryItemIcon {
                cell.configure(viewModel.iconBuilder.build(model))
            }
            
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DefaultEditCell.identifier, for: indexPath)
            if let cell = cell as? DefaultEditCell,
               let model = viewModel.tableItems[indexPath.row] as? NewCategoryItemText {
                cell.configure(title: model.title, subtitle: model.value)
            }
            
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

// MARK: - UITableViewDelegate
extension NewCategoryViewController: UITableViewDelegate {
    
}
