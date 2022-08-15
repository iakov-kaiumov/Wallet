//
//  CategoryListViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class CategoryListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: CategoryViewModel
    
    private lazy var nextButton: UIButton = ButtonFactory.makeGrayButton()
    private lazy var closeButton = UIButton(type: .system)
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
    
    // MARK: - Init
    init(viewModel: CategoryViewModel) {
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
    @objc private func closeButtonAction(sender: UIButton!) {
        viewModel.closeButtonDidTap()
    }
    
    @objc private func nextButtonAction(sender: UIButton!) {
        viewModel.closeButtonDidTap()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupCloseButton()
        setupTableView()
        setupNextButton()
        
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
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

extension CategoryListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.categories.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultEditCell.identifier, for: indexPath)
        if let cell = cell as? DefaultEditCell {
            if indexPath.section == 0 {
                let model = viewModel.categories[indexPath.row]
                cell.configure(title: model.name ?? "", subtitle: "")
                cell.accessoryType = model.id == viewModel.chosenCategory?.id ? .checkmark : .none
            } else {
                cell.configure(title: "Создать категорию", subtitle: "")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let oldRow = viewModel.categories.firstIndex(where: { $0.id == viewModel.chosenCategory?.id }) {
            let oldPath = IndexPath(row: oldRow, section: 0)
            tableView.cellForRow(at: oldPath)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        viewModel.cellDidTap(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension CategoryListViewController: UITableViewDelegate {
    
}
