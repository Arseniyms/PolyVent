//
//  Extensions.swift
//  EventPasser
//
//  Created by Arseniy Matus on 17.10.2022.
//

import UIKit

@available(iOS 13.0, *)
extension UITextField {
    func enablePasswordToggle() {
        var button = UIButton()
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .gray
            config.buttonSize = .mini
            config.baseBackgroundColor = .systemBackground
            button = UIButton(configuration: config)
        } else {
            button.tintColor = .gray
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
        }
        
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
                button.addTarget(self, action: #selector(toggleSecurity), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
    }

    @objc func toggleSecurity(sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
}

extension UITextField {
    func setBorderStyle(autocorrectionType: UITextAutocorrectionType = .yes, autocapitalizationType: UITextAutocapitalizationType = .sentences) {
        borderStyle = .roundedRect
        layer.cornerRadius = 4.0
        backgroundColor = .gray.withAlphaComponent(0.1)

        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
    }
}



