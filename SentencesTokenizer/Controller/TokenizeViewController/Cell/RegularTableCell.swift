//
//  RegularTableCell.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

class RegularTableCell:UITableViewCell {
    
    @IBOutlet weak var additionalButton: UIButton!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel:UILabel!
    
    private var additionalPressed:(()->())?
    
    func set(_ data:TableData.CellData, isSection:Bool = false) {
        set(text: data.title, image: data.image, isSection: isSection, isClear: data.isClear)
    }
    
    func set(text:String, image:String? = nil, isSection:Bool = false, isClear:Bool = false, button:TableData.SectionButton? = nil) {
        mainImageView.image = image != nil ? .init(systemName: image!) : nil
        mainImageView.isHidden = image == nil
        titleLabel.alpha = isClear ? Styles.lightColorOpacity : 1
        titleLabel.text = text
        titleLabel.font = isSection ? .systemFont(ofSize: 13, weight: .semibold) : .systemFont(ofSize: 15, weight: .regular)
        additionalButton.isHidden = button == nil
        if button?.pressed != nil {
            additionalButton.setTitle(button?.title, for: .normal)
        }
        additionalPressed = button?.pressed
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        print(#function)
        additionalPressed?()
    }
}
