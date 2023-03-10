//
//  ErrorPopup.swift
//  Wallet
//

import UIKit

class PopupView: UIView {
    private lazy var label: UILabel = UILabel()
    private lazy var imageView: UIImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configure(message: String, image: UIImage?) {
        label.text = message
        imageView.image = image
    }
    
    // MARK: - Private methods
    private func setup() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        setupImage()
        setupLabel()
    }
    
    private func setupLabel() {
        self.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
        
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        
    }
    
    private func setupImage() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
}
