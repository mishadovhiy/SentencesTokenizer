//
//  UITableView.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

extension UITableView {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }
}
