//
//  NewCategoryViewController.swift
//  Wallet

import UIKit
import SnapKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: NewCategoryViewModel
    private lazy var tableView: UITableView = UITableView()
    private lazy var nextButton: UIButton = ButtonFactory.makeGrayButton()
    private lazy var progressView = ProgressView()
    
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
    
    // MARK: - Actions
    @objc private func nextButtonAction() {
        viewModel.createCategory()
    }
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = .systemBackground
        title = R.string.localizable.newcategory_title()
        setupTableView()
        setupNextButton()
        setupProgressView()
        
        viewModel.showProgressView = { isOn in
            if isOn {
                self.progressView.show()
            } else {
                self.progressView.hide()
            }
        }
        
        viewModel.onItemChanged = { [weak self] row in
            self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        }
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
    
    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        nextButton.setTitle(R.string.localizable.default_save_button(), for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension NewCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.tableItems[indexPath.row]
        if item.type == .icon {
            let cell = tableView.dequeueReusableCell(withIdentifier: IconCell.identifier, for: indexPath)
            
            if let cell = cell as? IconCell {
                cell.configure(viewModel.iconBuilder.build(viewModel.model))
            }
            
            cell.accessoryType = .disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DefaultEditCell.identifier, for: indexPath)
            if let cell = cell as? DefaultEditCell {
                cell.configure(with: DefaultEditCellConfiguration(title: item.title, subtitle: item.value))
            }
            
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.cellDidTap(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

// MARK: - UITableViewDelegate
extension NewCategoryViewController: UITableViewDelegate {
    
}
