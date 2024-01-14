//
//  UITableViewCell.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

extension UITableViewCell {
    func setCornered(indexPath:IndexPath, dataCount:Int, for view:UIView, needCorners:Bool = true, value:CGFloat = Styles.viewCornerRadius) {
        let needCorners = needCorners ? (indexPath.row == 0 || indexPath.row == (dataCount - 1)) : false
        let isFullyCornered = dataCount == 1
        let topRadius = indexPath.row == 0
        
        if needCorners {
            if isFullyCornered {
                view.layer.cornerRadius = value
                view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            } else {
                view.layer.radius(value, at: topRadius ? .top : .bottom)
            }
            
        } else {
            view.layer.maskedCorners = []
        }
    }
    
    func setSelectionColor(_ uicolor:UIColor) {
        let view = UIView()
        view.backgroundColor  = uicolor
        self.selectedBackgroundView = view
    }
}
