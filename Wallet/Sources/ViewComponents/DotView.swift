//
//  DotView.swift
//  Wallet

import UIKit

class DotView: UIView {
    // MARK: - Init
    init(color: DotColor) {
        super.init(frame: .zero)
        setup()
        setColor(color: color)
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Methods
    func setColor(color: DotColor) {
        backgroundColor = color.getColor()
    }
    
    // MARK: - Private methods
    private func setup() {
        layer.cornerRadius = Constants.dotSize / 2.0
        translatesAutoresizingMaskIntoConstraints = false
        self.snp.makeConstraints {
            $0.width.equalTo(Constants.dotSize)
            $0.height.equalTo(Constants.dotSize)
        }
    }
    
}

// MARK: - Constants
fileprivate extension Constants {
    static let dotSize: CGFloat = 8
}
