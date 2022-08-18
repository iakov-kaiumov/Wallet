//
//  IconPickerViewController.swift
//  Wallet

import UIKit

final class IconPickerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: IconPickerViewModel
    private lazy var tableView: UITableView = UITableView()
    private lazy var saveButton: UIButton = ButtonFactory.makeGrayButton()
    
    // MARK: - Init
    
    init(viewModel: IconPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonAction() {
        viewModel.saveChoosedIcon()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        navigationController?.navigationBar.topItem?.title = R.string.localizable.icon_picker_title()
        view.backgroundColor = R.color.background()
        setupTableView()
        setupSaveButton()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

        tableView.register(CollectionContainerCell.self, forCellReuseIdentifier: CollectionContainerCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        saveButton.setTitle(R.string.localizable.icon_picker_save_button(), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }
}

// MARK: - UITableViewDataSource

extension IconPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return R.string.localizable.icon_picker_section_color()
        } else {
            return R.string.localizable.icon_picker_section_icon()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let collectionCell = cell as? CollectionContainerCell else { return }
        collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionContainerCell.identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return Constants.colorTableCellHeight(viewModel.model[indexPath.section].count, view.bounds.width)
        } else {
            return Constants.iconTableCellHeight(viewModel.model[indexPath.section].count, view.bounds.width)
        }
    }
}

// MARK: - UITableViewDelegate

extension IconPickerViewController: UITableViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension IconPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCollectionViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? IconCollectionViewCell {
            cell.configure(viewModel.getCollectionCellModel(section: collectionView.tag, row: indexPath.row))
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension IconPickerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            viewModel.didChooseColor(id: indexPath.row)
        } else {
            viewModel.didChooseIcon(id: indexPath.row)
        }
        tableView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension IconPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellSize, height: Constants.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return Constants.colorSpacing(self.view.bounds.width)
        } else {
            return Constants.iconSpacing(self.view.bounds.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var inset: CGFloat
        if collectionView.tag == 0 {
            inset = Constants.colorSpacing(self.view.bounds.width)
        } else {
            inset = Constants.iconSpacing(self.view.bounds.width)
        }
        return UIEdgeInsets(top: Constants.topInset, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView.tag == 0 {
            return Constants.colorSpacing(self.view.bounds.width)
        } else {
            return Constants.iconSpacing(self.view.bounds.width)
        }
    }
}

// MARK: - Constants

fileprivate extension Constants {
    static let cellSize: CGFloat = 50.0
    
    static let colorRowLength: CGFloat = 4.0
    
    static let iconRowLength: CGFloat = 5.0
    
    static let minimumSpacing: CGFloat = 5.0
    
    static let topInset: CGFloat = 16.0
    
    static let colorSpacing = { (width: CGFloat) -> CGFloat in
        max((width - cellSize * colorRowLength) / (colorRowLength + 2), minimumSpacing)
    }
    static let iconSpacing = { (width: CGFloat) -> CGFloat in
        max((width - cellSize * iconRowLength) / (iconRowLength + 2), minimumSpacing)
    }
    
    static let colorTableCellHeight = { (colorsCount: Int, width: CGFloat) -> CGFloat in
        CGFloat(colorsCount) / colorRowLength * (cellSize + colorSpacing(width)) - colorSpacing(width) + topInset
    }
    
    static let iconTableCellHeight = { (iconsCount: Int, width: CGFloat) -> CGFloat in
        CGFloat(iconsCount) / iconRowLength * (cellSize + iconSpacing(width)) - iconSpacing(width) + topInset
    }
}
