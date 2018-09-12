//
//  CanvasView.swift
//  iPaint
//
//  Created by Tabassum Shaikh on 9/10/18.
//  Copyright © 2018 TShaikh. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    // MARK: VARIABLES
    var lineColor: UIColor!
    var lineWidth: CGFloat!
    var path: UIBezierPath!     // what we want to draw in our canvas or UIView
    var touchPoint: CGPoint!    // where we're touching our view
    var startingPoint: CGPoint! // where the touches are beginning
    
    
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        
    }
    
    // MARK: UIEVENT RESPONDER METHODS
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startingPoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
        path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        
        startingPoint = touchPoint
        
        drawShapeLayer()
    }
    
    // MARK: DRAWING FUNCTION
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        //if there's no lineColor then start with black
        if lineColor == nil {
            lineColor = UIColor.black
        }
        shapeLayer.strokeColor = lineColor.cgColor
        
        //if there's no line width then start with 1
        if lineWidth == nil {
            lineWidth = 1
        }
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
        
        // Post Notfication stating that a path now exists on canvas
        NotificationCenter.default.post(name: .pathExists, object: nil )
    }
    
    // MARK: CLEAR CANVAS FUNCTION
    func clearCanvas() {
        
        path.removeAllPoints()
        if backgroundColor != .white {
            backgroundColor = .white
        }
        self.layer.sublayers = nil
        self.setNeedsDisplay()
        
    }
    
    
}

// MARK: POST NOTIFICATION EXTENSION
extension Notification.Name {
    static let pathExists = Notification.Name("pathExists")
    
}
