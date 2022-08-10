//
//  MainViewController.swift
//  Wallet
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: OnboardingViewModel
    private let onboardingImage: UIImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var loginButton = UIButton(type: .system)
    
    // MARK: - Init
    init(viewModel: OnboardingViewModel) {
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
        view.backgroundColor = .systemBackground
        
        setupOnboardingImage()
        setupTitleLabel()
        setupDescriptionLabel()
        setupLoginButton()
    }
    
    private func setupOnboardingImage() {
        view.addSubview(onboardingImage)
        
        onboardingImage.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.height.equalTo(341)
        }
        
        onboardingImage.image = UIImage(named: "OnboardingImage")
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(onboardingImage.snp.bottom).offset(24)
        }
        
        titleLabel.text = NSLocalizedString("onboarding_title", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
    }
    
    private func setupDescriptionLabel() {
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        descriptionLabel.text = NSLocalizedString("onboarding_description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        ButtonConfigure.configureGrayButton(loginButton)
        let title = NSLocalizedString("onboarding_login_button", comment: "")
        loginButton.setTitle(title, for: .normal)
    }
}

class ButtonConfigure {
    static func configureGrayButton(_ button: UIButton) {
        button.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = UIColor(named: "LoginButton")
        button.setTitleColor(.white, for: .normal)
    }
}
