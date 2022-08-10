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
    private let viewModel: WalletsViewModel
    private let helloLabel = UILabel()
    
    // MARK: - Init
    init(viewModel: WalletsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
