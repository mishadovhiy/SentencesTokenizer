//
//  CALayer.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import QuartzCore

extension CALayer {
    
    enum RadiusPosition {
        case top, left, right, bottom
    }
    
    func radius(_ value:CGFloat? = nil, at:RadiusPosition) {
        cornerRadius = value ?? (frame.height / 2)
        switch at {
        case .top:
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .left:
            maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .right:
            maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .bottom:
            maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    enum MoveDirection {
        case top
        case left
    }
    func move(_ direction:MoveDirection, value:CGFloat) {
        switch direction {
        case .top:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, 0, value, 0)
        case .left:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, value, 0, 0)
        }
    }
    
    func zoom(value:CGFloat) {
        self.transform = CATransform3DMakeScale(value, value, 1)
    }
    
    func caTransaction(_ duration:CFTimeInterval,
                       type:(CAMediaTimingFunctionName, CATransitionType) = (.linear, .fade), delegate:CAAnimationDelegate? = nil) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
                                                            type.0)
        animation.type = type.1
        animation.duration = duration
        
        if let delegate = delegate {
            animation.delegate = delegate
        }
        add(animation, forKey: type.1.rawValue)
    }
}
