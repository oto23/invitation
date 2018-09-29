//
//  GradientView.swift
//  Invitation
//
//  Created by Erick Sanchez on 9/28/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var colors:   [UIColor] = [#colorLiteral(red: 0.09411764706, green: 0.5764705882, blue: 0.6392156863, alpha: 1), #colorLiteral(red: 0.3450980392, green: 0.7607843137, blue: 0.7960784314, alpha: 1), #colorLiteral(red: 0.8, green: 0.8509803922, blue: 0.7568627451, alpha: 1), #colorLiteral(red: 0.9098039216, green: 0.7725490196, blue: 0.6470588235, alpha: 1)] { didSet { updateColors() }}

    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    override var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
    
    func updatePoints() {
        if horizontalMode {
            layer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            layer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            layer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            layer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        guard colors.count > 1 else { return }
        
        layer.locations = (0..<colors.count).map { 1.0 / Double(colors.count - 1) * Double($0) }.map(NSNumber.init)
    }
    func updateColors() {
        layer.colors    = colors.map { $0.cgColor }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
    
//    private lazy var gradientLayer: CAGradientLayer = {
//        let layer = CAGradientLayer()
//        layer.colors
//
//        return layer
//    }()
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        gradientLayer.bounds = self.bounds
//    }
}

extension UIView {
    func applyGradient() {
        let gradient = GradientView(frame: self.bounds)
        gradient.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.insertSubview(gradient, at: 0)
    }
}
