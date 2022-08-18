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
    private lazy var progressView = ProgressView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        tableView.register(IconCell.self, forCellReuseIdentifier: IconCell.identifier)
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
    
    // MARK: - Actions
    @objc private func nextButtonAction(sender: UIButton!) {
        viewModel.closeButtonDidTap()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        title = R.string.localizable.category_picker_title()
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
        
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
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
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: IconCell.identifier, for: indexPath)
            let model = viewModel.categories[indexPath.row]
            if let cell = cell as? IconCell {
                cell.configure(viewModel.iconBuilder.build(model, iconAlignment: .leading))
            }
            cell.accessoryType = model.id == viewModel.chosenCategory?.id ? .checkmark : .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DefaultEditCell.identifier, for: indexPath)
            if let cell = cell as? DefaultEditCell {
                cell.configure(with: DefaultEditCellConfiguration(title: "Создать категорию", titleColor: R.color.accentPurple()))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if let oldRow = viewModel.categories.firstIndex(where: { $0.id == viewModel.chosenCategory?.id }) {
                let oldPath = IndexPath(row: oldRow, section: 0)
                tableView.cellForRow(at: oldPath)?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        viewModel.cellDidTap(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
}

extension CategoryListViewController: UITableViewDelegate {
    
}
