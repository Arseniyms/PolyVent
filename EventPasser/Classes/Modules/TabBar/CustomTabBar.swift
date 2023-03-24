//
//  CustomTabBar.swift
//  EventPasser
//
//  Created by Arseniy Matus on 05.12.2022.
//

import UIKit

@available(*, deprecated)
class CustomTabBar: UITabBar {
    private var tabBarWidth: CGFloat { self.bounds.width }
    private var tabBarHeight: CGFloat { self.bounds.height }
    private var centerWidth: CGFloat { self.bounds.width / 2 }
    private let circleRadius: CGFloat = 27

    private var shapeLayer: CALayer?
    private var circleLayer: CALayer?

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let pointIsInside = super.point(inside: point, with: event)
            if pointIsInside == false {
            for subview in subviews {
                let pointInSubview = subview.convert(point, from: self)
                if subview.point(inside: pointInSubview, with: event) {
                    return true
                }
            }
        }
        return pointIsInside
    }
    
    override func draw(_ rect: CGRect) {
        drawTabBar()
        self.tintColor = .dynamic(light: .black, dark: .white)
    }
    
    private func shapePath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -1, y: 0))
        path.addLine(to: CGPoint(x: tabBarWidth + 1, y: 0))
        path.addLine(to: CGPoint(x: tabBarWidth, y: tabBarHeight + 1))
        path.addLine(to: CGPoint(x: 0, y: tabBarHeight + 1))
        path.close()
        return path.cgPath
    }

    private func circlePath() -> CGPath {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 12),
                    radius: circleRadius,
                    startAngle: 180 * .pi / 180,
                    endAngle: 0 * 180 / .pi,
                    clockwise: true)
        return path.cgPath
    }

    private func drawTabBar() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapePath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.customBackgroundColor.cgColor
        shapeLayer.lineWidth = 1.0

        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath()
        circleLayer.strokeColor = UIColor.systemGray.cgColor
        circleLayer.fillColor = UIColor.customBackgroundColor.cgColor
        circleLayer.lineWidth = 1.0

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        if let oldCircleLayer = self.circleLayer {
            self.layer.replaceSublayer(oldCircleLayer, with: circleLayer)
        } else {
            self.layer.insertSublayer(circleLayer, at: 1)
        }

        self.shapeLayer = shapeLayer
        self.circleLayer = circleLayer
    }

}
