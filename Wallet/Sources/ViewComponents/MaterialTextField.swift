//
//  MaterialTextField.swift
//  Wallet
//

import UIKit

final private class MaterialTextFieldLabel: UIView {
    // MARK: - Properties
    private let label: UILabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.addSubview(label)
        
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel

        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    var text: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }
}

final class MaterialTextField: UIView {
    // MARK: - Properties
    
    enum Format {
        case any, decimal
    }
    
    private lazy var label: MaterialTextFieldLabel = MaterialTextFieldLabel()
    
    private lazy var errorIcon: UIImageView = UIImageView()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no

        return textField
    }()

    private lazy var border: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 3
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    var format: Format = .any
    
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var keyboardType: UIKeyboardType {
        get {
            textField.keyboardType
        }
        set {
            textField.keyboardType = newValue
        }
    }
    
    var prompt: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }
    
    private lazy var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = " "
        return formatter
    }()
    
    private var allowedDecimalCharacters: CharacterSet = CharacterSet.decimalDigits

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Pulblic Methods
    func showError() {
        errorIcon.isHidden = false
        border.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    func hideError() {
        errorIcon.isHidden = true
        border.layer.borderColor = UIColor.systemGray5.cgColor
    }

    // MARK: - Private Methods
    private func setup() {
        setupLabelAndBorder()
        setupTextField()
        setupErrorIcon()
    }
    
    private func setupLabelAndBorder() {
        addSubview(border)
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.top.equalToSuperview()
        }
        
        border.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(label.snp.centerY)
            $0.height.equalTo(50)
        }
    }
    
    private func setupTextField() {
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(label.snp.centerY)
            $0.height.equalTo(50)
        }
        textField.delegate = self
    }
    
    private func setupErrorIcon() {
        addSubview(errorIcon)
        errorIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(textField.snp.centerY)
        }
        errorIcon.image = R.image.alertImage()
        errorIcon.isHidden = true
    }
}

extension MaterialTextField: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        hideError()
        if format == .any {
            return true
        }
        
        if let groupingSeparator = decimalFormatter.groupingSeparator {

            if string == groupingSeparator {
                return true
            }

            if let textWithoutGroupingSeparator = textField.text?.replacingOccurrences(of: groupingSeparator, with: "") {
                var totalTextWithoutGroupingSeparators = textWithoutGroupingSeparator + string
                if string.isEmpty { // pressed Backspace key
                    totalTextWithoutGroupingSeparators.removeLast()
                }
                if let numberWithoutGroupingSeparator = totalTextWithoutGroupingSeparators.toDecimal,
                    let formattedText = decimalFormatter.string(from: numberWithoutGroupingSeparator as NSNumber) {

                    textField.text = formattedText
                    return false
                }
            }
        }
        let characterSet = CharacterSet(charactersIn: string)
        return allowedDecimalCharacters.isSuperset(of: characterSet)
    }
}
