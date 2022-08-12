//
//  TextInputViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class TextInputViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: TextInputViewModel
    
    private let nextButton: UIButton = ButtonFactory.makeGrayButton()
    private let textField: MaterialTextField = MaterialTextField()
    private let closeButton = UIButton(type: .system)
    
    // MARK: - Init
    init(viewModel: TextInputViewModel) {
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
    @objc private func closeButtonAction(sender: UIButton!) {
        viewModel.closeButtonDidTap()
    }
    
    @objc private func nextButtonAction(sender: UIButton!) {
        viewModel.onNewValue(textField.text)
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        
        if !viewModel.isModal {
            self.navigationItem.title = viewModel.title
        }
        
        setupCloseButton()
        setupNextButton()
        setupTextField()
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        
        let topConstraint = viewModel.isModal ? closeButton.snp.bottom : view.safeAreaLayoutGuide.snp.top
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(topConstraint).offset(24)
            $0.height.equalTo(54)
        }
        
        textField.text = viewModel.text
        textField.prompt = viewModel.textInputPrompt
        textField.keyboardType = viewModel.keyboardType
        if viewModel.keyboardType == .numberPad {
            textField.allowedCharacters = CharacterSet.decimalDigits
        }
    }
    
    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        nextButton.setTitle(viewModel.buttonTitle, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
    }
    
    private func setupCloseButton() {
        guard viewModel.isModal else { return }
        
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
        
        closeButton.setTitle(R.string.localizable.modal_close_button(), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }
}
