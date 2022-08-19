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
        
        label.font = .systemFont(ofSize: 12)
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
    
    private let label: MaterialTextFieldLabel = MaterialTextFieldLabel()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no

        return textField
    }()

    lazy var border: UIView = {
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

    // MARK: - Private Methods
    private func setup() {
        self.addSubview(border)
        self.addSubview(label)
        self.addSubview(textField)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.top.equalToSuperview()
        }
        
        border.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(label.snp.centerY)
        }
        
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(label.snp.centerY)
        }
        
        textField.delegate = self
    }
}

extension MaterialTextField: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
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
