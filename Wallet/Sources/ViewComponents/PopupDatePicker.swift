//
//  PopupDatePicker.swift
//  Wallet
//

import UIKit

class PopupDatePicker: UIView {
    
    var onValueChanged: ((Date) -> Void)?
    var onDismissed: (() -> Void)?

    private let datePicker: UIDatePicker = {
        let v = UIDatePicker()
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)

        let pickerHolderView: UIView = {
            let v = UIView()
            v.backgroundColor = .white
            v.layer.cornerRadius = 8
            return v
        }()
        
        [blurredEffectView, pickerHolderView, datePicker].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(blurredEffectView)
        pickerHolderView.addSubview(datePicker)
        addSubview(pickerHolderView)
        
        NSLayoutConstraint.activate([
            
            blurredEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

            pickerHolderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            pickerHolderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            pickerHolderView.centerYAnchor.constraint(equalTo: centerYAnchor),

            datePicker.topAnchor.constraint(equalTo: pickerHolderView.topAnchor, constant: 20.0),
            datePicker.leadingAnchor.constraint(equalTo: pickerHolderView.leadingAnchor, constant: 20.0),
            datePicker.trailingAnchor.constraint(equalTo: pickerHolderView.trailingAnchor, constant: -20.0),
            datePicker.bottomAnchor.constraint(equalTo: pickerHolderView.bottomAnchor, constant: -20.0)

        ])
        
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
