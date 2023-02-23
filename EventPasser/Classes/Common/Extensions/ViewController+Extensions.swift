//
//  LabelExtensions.swift
//  EventPasser
//
//  Created by Arseniy Matus on 20.10.2022.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    func getPasswordTextField() -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20, weight: .light)
        textField.setBorderStyle(autocorrectionType: .no, autocapitalizationType: .none)
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        textField.textContentType = .oneTimeCode
        if #available(iOS 13.0, *) {
            textField.enablePasswordToggle()
        } else {
            textField.isSecureTextEntry = true
        }
        textField.delegate = self
        
        return textField
    }
    
    func getInfoLabel(_ info: String = "") -> UILabel {
        let label = UILabel()
        label.text = info
        label.lineBreakMode = .byClipping
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        return label
    }
    
    func getInfoTextField() -> UITextField {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20, weight: .light)
        textField.delegate = self
        return textField
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
