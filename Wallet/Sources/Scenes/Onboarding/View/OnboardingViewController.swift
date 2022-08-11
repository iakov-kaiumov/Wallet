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
    private let loginButton = ButtonFactory.makeGrayButton()
    
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        
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
        
        onboardingImage.image = R.image.onboardingImage()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(onboardingImage.snp.bottom).offset(24)
        }
        
        titleLabel.text = R.string.localizable.onboarding_title()
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
    }
    
    private func setupDescriptionLabel() {
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        descriptionLabel.text = R.string.localizable.onboarding_description()
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 0
    }
    
    private func setupLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        let title = R.string.localizable.onboarding_login_button()
        loginButton.setTitle(title, for: .normal)
    }
}
