//
//  WalletsViewController.swift
//  Wallet
//
//  Created by Ярослав Ульяненков on 10.08.2022.
//

import UIKit
import SnapKit

class WalletsViewController: UIViewController {
    // MARK: - Properties
    let viewModel: WalletsViewModel
    let headerView: HeaderView
    
    // MARK: - Init
    init(viewModel: WalletsViewModel) {
        self.viewModel = viewModel
        self.headerView = HeaderView()
        super.init(nibName: nil, bundle: nil)
        headerView.setData(balance: 23.45, income: 12, expences: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.color.background()
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
    }
    
    // MARK: - Private methods
    func setupHeader() {
        
    }
}
