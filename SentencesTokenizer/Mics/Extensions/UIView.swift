//
//  UIView.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

extension UIView {
    func addConstraints(_ constraints:[NSLayoutConstraint.Attribute:CGFloat]) {
        constraints.forEach { (key, value) in
            let keyNil = key == .height || key == .width
            if let toView = self.superview {
                let item:Any? = keyNil ? nil : toView
                toView.addConstraint(.init(item: self, attribute: key, relatedBy: .equal, toItem: item, attribute: key, multiplier: 1, constant: value))
            }
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func copy<T: UIView>(toView:UIView?, frame:CGRect?) -> T {
        let new = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
        if let toView = toView {
            new.layer.zPosition = 9999
            new.isHidden = false
            new.layer.name = UUID().uuidString
            toView.addSubview(new)
            new.frame = frame ?? self.frame
            new.subviews.forEach({
                $0.frame = .init(origin: .zero, size: new.frame.size)
            })
        }
        return new
    }
}
