//
//  PopupDatePicker.swift
//  Wallet
//

import UIKit

class PopupDatePicker: UIView {
    
    var onValueChanged: ((Date) -> Void)?
    var onDismissed: (() -> Void)?

    private lazy var datePicker: UIDatePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)

        let pickerHolderView: UIView = {
            let v = UIView()
            v.backgroundColor = .systemBackground
            v.layer.cornerRadius = 8
            return v
        }()

        addSubview(blurredEffectView)
        pickerHolderView.addSubview(datePicker)
        addSubview(pickerHolderView)
        
        blurredEffectView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        pickerHolderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(pickerHolderView).inset(20)
        }
        
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            // use default
        }
        
        datePicker.addTarget(self, action: #selector(didChangeDate(_:)), for: .valueChanged)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        blurredEffectView.addGestureRecognizer(recognizer)
    }
    
    @objc func tapHandler(_ g: UITapGestureRecognizer) {
        onDismissed?()
    }
    
    @objc func didChangeDate(_ sender: UIDatePicker) {
        onValueChanged?(sender.date)
    }
    
}
