//
//  WalletEditViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class WalletEditViewController: UIViewController {
    private let cellIdentifier = "Cell"
    
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)

         tableView.dataSource = self
         tableView.delegate = self
         tableView.allowsSelection = true
         tableView.allowsMultipleSelection = false
         tableView.separatorStyle = .none

         tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

         return tableView
    }()
    
    // MARK: - Init
    init(viewModel: OnboardingViewModel) {
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
        navigationController?.navigationBar.topItem?.title = "My title"
        
        setupTableView()
    }
    
    private func setupTableView() {
         view.addSubview(tableView)

         tableView.snp.makeConstraints {
             $0.leading.trailing.bottom.equalToSuperview()
             $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
         }
     }
}

extension WalletEditViewController: UITableViewDataSource {

     func numberOfSections(in tableView: UITableView) -> Int {
         1
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         1
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

         if cell == nil {
             cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
         }

         cell?.textLabel?.text = "Label"
         cell?.accessoryType = .disclosureIndicator
         return cell!
     }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
     }
 }

 extension WalletEditViewController: UITableViewDelegate {

 }
