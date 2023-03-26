//
//  Button+Extension.swift
//  EventPasser
//
//  Created by Arseniy Matus on 24.03.2023.
//

import UIKit

extension UIButton {
    func makeLivePressing() {
        self.addTarget(self, action: #selector(highlightButton), for: [.touchDragEnter, .touchDragInside, .touchDown])
        self.addTarget(self, action: #selector(unhighlightButton), for: [.touchDragExit, .touchDragOutside, .touchUpInside, .touchCancel])
    }
    
    @objc private func highlightButton(button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    @objc private func unhighlightButton(button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.transform = CGAffineTransform.identity
        }
    }
}
