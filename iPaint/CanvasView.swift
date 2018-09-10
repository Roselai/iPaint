//
//  CanvasView.swift
//  iPaint
//
//  Created by Shukti Shaikh on 9/10/18.
//  Copyright © 2018 TShaikh. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    
    //TODO: Make customizable in UI, as well as opacity for line color
    var lineColor: UIColor!
    var lineWidth: CGFloat!
    var path: UIBezierPath!     // what we want to draw in our canvas or UIView
    var touchPoint: CGPoint!    // where we're touching our view
    var startingPoint: CGPoint! // where the touches are beginning
    
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        
        lineColor = UIColor.black
        lineWidth = 10
    }
    
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
    
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearCanvas() {
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
