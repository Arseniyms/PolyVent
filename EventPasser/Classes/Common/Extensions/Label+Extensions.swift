//
//  LabelExtensions.swift
//  EventPasser
//
//  Created by Arseniy Matus on 01.11.2022.
//

import UIKit

extension InfoLabel {
    static func profileInfo(of info: String = "") -> InfoLabel {
        let label = InfoLabel()
        label.text = "\(info)"
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray.cgColor
        label.layer.cornerRadius = 5
        label.textAlignment = .natural
        label.edgeInsets(top: 0, bottom: 0, left: 10, right: 10)
        
        return label
    }
}
