//
//  ImageView+Extensions.swift
//  EventPasser
//
//  Created by Arseniy Matus on 12.12.2022.
//

import UIKit

extension UIImageView {
    static func withRoundedBackground(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image?
            .withInset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))?
            .withRenderingMode(.alwaysTemplate)
        
        imageView.tintColor = .buttonColor
        
        imageView.backgroundColor = .systemBlue.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 15
        
        return imageView
    }
}
