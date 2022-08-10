//
//  MainViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: MainViewModel
    private let helloLabel = UILabel()
    
    // MARK: - Init
    init(viewModel: MainViewModel) {
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
        view.backgroundColor = .yellow
        view.addSubview(helloLabel)
        setupHelloLabel()
        helloLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupHelloLabel() {
        helloLabel.text = "hello"
    }
}
