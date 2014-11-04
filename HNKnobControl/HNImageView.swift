//
//  HNImageView.swift
//  HNKnobControl
//
//  Created by Hugo Nordell on 10/28/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

import UIKit

protocol HNImageViewDelegate {
    func didChangeAngle(sender: HNImageView)
//    func didHitMaxAngle()
//    func didHitMinAngle()
}

class HNImageView: UIImageView, UIGestureRecognizerDelegate, HNRotationGestureRecognizerDelegate {

    var imageAngle: CGFloat = 0.0
    var minAngle: CGFloat = -1000.0
    var maxAngle: CGFloat = 1000.0
    var gestureRecognizer: HNRotationGestureRecognizer!
    var delegate: HNImageViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        setupGestureRecognizer()
    }
    
    init(frame: CGRect, minAngle: CGFloat, maxAngle: CGFloat) {
        super.init(frame: frame)
        self.minAngle = minAngle
        self.maxAngle = maxAngle
        self.userInteractionEnabled = true
        setupGestureRecognizer()
    }
    
    override init(image: UIImage!) {
        super.init(image: image)
        self.userInteractionEnabled = true
        setupGestureRecognizer()
    }
    
    init(image: UIImage!, minAngle: CGFloat, maxAngle: CGFloat) {
        super.init(image: image)
        self.minAngle = minAngle
        self.maxAngle = maxAngle
        self.userInteractionEnabled = true
        setupGestureRecognizer()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotation(angle: CGFloat) {
        if (((imageAngle+angle) <= maxAngle) && (imageAngle+angle) >= minAngle) {
            imageAngle += angle
            
            /** This is only useful if the rotation doesn't have a relative rotation connected to it. E.g. let's say you want one full revolution to be equivalent to cranking up the volume to 500 decibel. Then you need a scaling factor such as 2*pi / 500 to achieve that effect. In that case remove the if else if below.
            */
            if angle > 360 {
                imageAngle -= 360
            } else if imageAngle < -360 {
                imageAngle += 360
            }
            
            // Rotate the knob
            self.transform = CGAffineTransformMakeRotation(imageAngle * CGFloat(M_PI / 180.0))
            
            // Angle change
            if delegate != nil {
                delegate?.didChangeAngle(self)
            }
        }
    }
    
    func finalAngle(angle: CGFloat) {
        return
    }
    
    func setupGestureRecognizer() {
        let centerPoint = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2)
        
        // Circular image
        let outerRadius = CGFloat(self.frame.size.width/2 + 20)
        
        println(outerRadius)
        
        gestureRecognizer = HNRotationGestureRecognizer(centerPoint: centerPoint, innerRadius: outerRadius/3, outerRadius: outerRadius, target: self)
        
        self.addGestureRecognizer(gestureRecognizer)
    }

}
