//
//  MainViewController.swift
//  Wallet
//

import UIKit
import SnapKit
import AuthenticationServices

final class OnboardingViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: OnboardingViewModel
    private lazy var onboardingImage: UIImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var googleSignInButton = UIButton(type: .system)
    private lazy var appleSignInButton = ASAuthorizationAppleIDButton()
    private lazy var progressView = ProgressView()
    
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
    
    // MARK: - Actions
    @objc private func loginButtonAction() {
        viewModel.googleButtonDidTap(presenting: self)
    }
    
    @objc private func handleAppleIdRequest() {
        viewModel.appleButtonDidTap()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupOnboardingImage()
        setupTitleLabel()
        setupDescriptionLabel()
        setupGoogleButton()
        setupAppleButton()
        setupProgressView()
        
        viewModel.showProgressView = { isOn in
            if isOn {
                self.progressView.show()
            } else {
                self.progressView.hide()
            }
        }
    }
    
    private func setupOnboardingImage() {
        view.addSubview(onboardingImage)
        
        guard let image = R.image.onboardingImage() else {
            return
        }
        let imageWidth = view.bounds.width - 16 * 2
        let imageHeight = imageWidth / image.size.width * image.size.height
        
        onboardingImage.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.width.equalTo(imageWidth)
            $0.height.equalTo(imageHeight)
            
            $0.centerX.equalToSuperview()
        }
        onboardingImage.image = image
        
        onboardingImage.layer.cornerRadius = 16
        onboardingImage.clipsToBounds = true
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
    
    private func setupAppleButton() {
        view.addSubview(appleSignInButton)
        
        appleSignInButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        appleSignInButton.cornerRadius = 16
        appleSignInButton.tintColor = R.color.loginButton()
        
        appleSignInButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(googleSignInButton.snp.leading).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(56)
        }
    }
    
    private func setupGoogleButton() {
        view.addSubview(googleSignInButton)
        
        googleSignInButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
//        let title = R.string.localizable.onboarding_login_button()
//        googleSignInButton.setTitle(title, for: .normal)
        googleSignInButton.setImage(R.image.google(), for: .normal)
        let imageInset: CGFloat = 12
        googleSignInButton.imageEdgeInsets = UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset)
        googleSignInButton.backgroundColor = R.color.loginButton()
        googleSignInButton.layer.cornerRadius = 16

        googleSignInButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
