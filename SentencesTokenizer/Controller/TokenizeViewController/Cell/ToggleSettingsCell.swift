//
//  ToggleSettingsCell.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

class ToggleSettingsCell:ClearCell {
    
    @IBOutlet private weak var settingImageView:UIImageView!
    
    func set(image:String) {
        settingImageView.image = .init(systemName: image)
    }
}
