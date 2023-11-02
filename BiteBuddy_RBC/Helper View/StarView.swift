//
//  StarView.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 29/10/23.
//

import UIKit

class StarsView: UIImageView {
    
     var rating: Double = 5.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // get BezierPath half/full star
    private func starPath(height: CGFloat, full: Bool) -> UIBezierPath {
        let fullPoints = [CGPoint(x: 0.5, y: 0.03), CGPoint(x: 0.61, y: 0.38), CGPoint(x: 0.99, y: 0.38), CGPoint(x: 0.68, y: 0.61), CGPoint(x: 0.8, y: 0.97), CGPoint(x: 0.5, y: 0.75), CGPoint(x: 0.2, y: 0.97), CGPoint(x: 0.32, y: 0.61), CGPoint(x: 0.01, y: 0.38), CGPoint(x: 0.39, y: 0.38)].map({ CGPoint(x: $0.x * height, y: $0.y * height) })
        
        let halfPoints = [CGPoint(x: 0.5, y: 0.03), CGPoint(x: 0.5, y: 0.75), CGPoint(x: 0.2, y: 0.97), CGPoint(x: 0.32, y: 0.61), CGPoint(x: 0.01, y: 0.38), CGPoint(x: 0.39, y: 0.38)].map({ CGPoint(x: $0.x * height, y: $0.y * height) })
        let points = full ? fullPoints : halfPoints
        let starPath = UIBezierPath()
        guard let last = points.last else { return starPath }
        starPath.move(to: last)
        for point in points {
            starPath.addLine(to: point)
        }
        return starPath
    }
    
    //return shape layer from cgpath (full/half)
    private func starLayer(full: Bool) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = starPath(height: bounds.size.height, full: full).cgPath
        shapeLayer.fillColor = UIColor.systemOrange.cgColor
        return shapeLayer
    }
    
    //clear subview and add new subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        let sublayers = layer.sublayers
        for sublayer in sublayers ?? [] {
            sublayer.removeFromSuperlayer()
        }
        for i in 1...5 {
            if rating >= Double(i) - 0.5 {
                let star = starLayer(full: rating >= Double(i))
                star.transform = CATransform3DMakeTranslation(bounds.size.height * CGFloat(i - 1), 0, 0)
                layer.addSublayer(star)
            }
        }
    }
}
