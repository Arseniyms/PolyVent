//
//  View+Extensions.swift
//  EventPasser
//
//  Created by Arseniy Matus on 03.12.2022.
//

import UIKit

extension UIView {
    func shimmerEffectView() {
        let gradientBackground: CGColor = UIColor.systemGray.cgColor
        let gradientBackgroundMove: CGColor = UIColor.white.cgColor
        let shimmerStartLocation: [NSNumber] = [-1.0, -0.5, 0.0]
        let shimmerEndLocation: [NSNumber] = [1.0, 1.5, 2.0]
        var shimmerGradienLayer: CAGradientLayer!

        let gradientLayered = CAGradientLayer()
        gradientLayered.frame = self.bounds
        gradientLayered.cornerRadius = 5
        gradientLayered.startPoint = CGPoint(x: 0, y: 1)
        gradientLayered.endPoint = CGPoint(x: 1, y: 1)
        gradientLayered.colors = [gradientBackground,
                                  gradientBackgroundMove,
                                  gradientBackground]
        gradientLayered.locations = shimmerStartLocation
        gradientLayered.name = "shimmerEffectView"
        self.layer.addSublayer(gradientLayered)

        shimmerGradienLayer = gradientLayered

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = shimmerStartLocation
        animation.toValue = shimmerEndLocation
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1.8
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        shimmerGradienLayer?.add(animationGroup, forKey: animation.keyPath)
    }

    func shimmerStopAnimate() {
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer.name == "shimmerEffectView" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

extension UIView {
    func startShimmering() {
        let light = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        let dark = UIColor.black.cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]
        self.layer.mask = gradient

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]

        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmering")
    }

    func stopShimmering() {
        func stopShimmering() {
            self.layer.mask = nil
        }
    }
}
