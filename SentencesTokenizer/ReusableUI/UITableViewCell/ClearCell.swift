//
//  ClearCell.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

class ClearCell:UITableViewCell {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setSelectionColor(.clear)
    }
}
