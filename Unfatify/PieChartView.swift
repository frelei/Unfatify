//
//  PieChartView.swift
//  Unfatify
//
//  Created by Rodrigo Leite on 07/10/15.
//  Copyright © 2015 kobe. All rights reserved.
//

import UIKit
import QuartzCore


/// PieChartView draw on a UIView Pie chart
@IBDesignable
class PieChartView: UIView {


    private var backgroundLayer : CAShapeLayer!
    private var pieOverlay : CAShapeLayer!
    private var lineWith: Double = 0.0
    
    @IBInspectable var backgroundOverlay: UIColor!
    @IBInspectable var backgroundColorView: UIColor!
    
    @IBInspectable
    var piePercentage: Double = 10{
        willSet(newPiePercent){ updatePiePercentage(newPiePercent) }
    }
    
    //MARK: DRAWING
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundLayer = CAShapeLayer()
        pieOverlay = CAShapeLayer()
        lineWith = Double(self.frame.size.width/30)
        
        layer.addSublayer(backgroundLayer)
        
        let rect = CGRectInset(bounds, CGFloat(lineWith/2), CGFloat(lineWith/2))
        let path = UIBezierPath(ovalInRect: rect)
        
        backgroundLayer.path = path.CGPath
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = CGFloat(lineWith)
        backgroundLayer.strokeColor =  UIColor.lightGreenUnfatify().CGColor
        backgroundLayer.frame = bounds
        
        layer.addSublayer(pieOverlay)
        pieOverlay.path = path.CGPath
        pieOverlay.fillColor = nil
        pieOverlay.lineWidth = CGFloat(lineWith)
        pieOverlay.strokeColor =  UIColor.redUnfatify().CGColor
        pieOverlay.transform = CATransform3DMakeRotation(CGFloat(-M_PI/2), 0, 0, 1)
        pieOverlay.frame = bounds
        
        updateLayerPropertie()
    }
    
    
    func updateLayerPropertie(){
        self.pieOverlay.strokeEnd = CGFloat(piePercentage/100)
    }
    
    func updatePiePercentage( newPercentage: Double ){
        
        if let pie = self.pieOverlay{
            CATransaction.begin()
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = (newPercentage/100 - piePercentage/100) * 2
            animation.fromValue = piePercentage / 100
            animation.toValue = newPercentage / 100
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            CATransaction.setCompletionBlock { () -> Void in
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                pie.strokeEnd = CGFloat(newPercentage / 100)
                CATransaction.commit()
            }
            
            pie.addAnimation(animation, forKey: "animateStroke")
            
            CATransaction.commit()
        }
    }
    

}
