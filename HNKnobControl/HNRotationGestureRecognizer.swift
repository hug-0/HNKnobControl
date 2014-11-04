//
//  HNRotationGestureRecognizer.swift
//  HNKnobControl
//
//  Created by Hugo Nordell on 10/25/14.
//  Copyright (c) 2014 hugo. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit

/** Rotation gesture delegate with optional implementations */
@objc protocol HNRotationGestureRecognizerDelegate {
    optional func rotation(angle: CGFloat)
    optional func finalAngle(angle: CGFloat)
}

class HNRotationGestureRecognizer: UIGestureRecognizer {

    /* Setup variables */
    var centerPoint: CGPoint!
    var innerRadius: CGFloat!
    var outerRadius: CGFloat!
    var cumulatedAngle: CGFloat = 0.0
    
    /* Delegate target */
    var target: HNRotationGestureRecognizerDelegate? = nil
    
    init(centerPoint: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, target: HNRotationGestureRecognizerDelegate) {
        super.init(target: target, action: nil)
        
        self.centerPoint = centerPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.target = target
    }
    
    /* Override functions for delegate protocol */
    
    /** Resets the cumulated Angle up to this point */
    override func reset() {
        super.reset()
        cumulatedAngle = 0
    }
    
    /** Called when touchesBegan with specified event */
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event)
        
        if touches.count != 1 {
            self.state = UIGestureRecognizerState.Failed
            
            return
        }
    }
    
    /** Called when touchesMoved with specified event */
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event)
        
        if self.state == UIGestureRecognizerState.Failed { return }
        
        if let touchObject: AnyObject = touches.anyObject() {
            let currentPoint: CGPoint = touchObject.locationInView(self.view)
            let previousPoint: CGPoint = touchObject.previousLocationInView(self.view)
            
            // Check that currentPoint is inside given area
            let distance = distanceBetweenPoints(centerPoint, secondPoint: currentPoint)
            if innerRadius <= distance && distance <= outerRadius {
                // Find angle between the two points (lines from center)
                var angle = angleBetweenLines(centerPoint, firstLineEnd: previousPoint, secondLineBegin: centerPoint, secondLineEnd: currentPoint, inDegrees: true)
                
                // If value is past 12 o'clock, move it
                if angle > 180.0 { angle -= 360.0 }
                else if angle < -180.0 { angle += 360.0 }
                
                // Sum cumulated angle
                cumulatedAngle += angle
                
                // Call delegate
                target?.rotation!(angle)
            }
        } else {
            // Touch went outside rotation area
            self.state = .Failed
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event)
        
        if self.state == .Possible {
            self.state = UIGestureRecognizerState.Ended
            target?.finalAngle!(cumulatedAngle)
        } else {
            self.state = .Failed
        }
        
        // Reset angle regardless of success/fail
        cumulatedAngle = 0.0
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        
        self.state = .Failed
        cumulatedAngle = 0.0
    }
    
    
    /* Utility methods */
    
    /** Returns euclidian distance between first and second point */
    func distanceBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let dx = firstPoint.x - secondPoint.x
        let dy = firstPoint.y - secondPoint.y
        return sqrt(dx*dx + dy*dy)
    }
    
    /** Returns the angle between two non-parallell lines in a plane in radians or degrees */
    func angleBetweenLines(firstLineBegin: CGPoint, firstLineEnd: CGPoint, secondLineBegin: CGPoint, secondLineEnd: CGPoint, inDegrees: Bool=true) -> CGFloat {
        let atanFirst = atan2(firstLineEnd.x - firstLineBegin.x, firstLineEnd.y - firstLineBegin.y)
        let atanSecond = atan2(secondLineEnd.x - secondLineBegin.x, secondLineEnd.y - secondLineBegin.y)
        return inDegrees ? (atanFirst - atanSecond) * 180 / CGFloat(M_PI) : atanFirst - atanSecond
    }
    
}
