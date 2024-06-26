//
//  ColorExtensions.swift
//  EventPasser
//
//  Created by Arseniy Matus on 18.10.2022.
//

import UIKit


extension UIColor {
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark:
                    return dark
                case .light, .unspecified:
                    return light
                @unknown default:
                    assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                    return light
                }
            })
        }
        
        // iOS 12 and earlier
        return light
    }
    
    public class var customBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
    
    public class var buttonColor: UIColor {
        .init(red: 55 / 255, green: 179 / 255, blue: 74 / 255, alpha: 1.0)
//        .init(red: 86 / 255, green: 105 / 255, blue: 255 / 255, alpha: 1.0)
    }
    
    public class var setTicketButtonColor: UIColor {
        .init(red: 46 / 255, green: 163 / 255, blue: 59 / 255, alpha: 1.0)
    }
    
    public class var unsetTicketButtonColor: UIColor {
        .init(red: 219 / 255, green: 53 / 255, blue: 25 / 255, alpha: 1.0)
    }
}
