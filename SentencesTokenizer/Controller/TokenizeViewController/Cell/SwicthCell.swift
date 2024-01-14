//
//  SwicthCell.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

class SwitchCell: ClearCell {
    
    @IBOutlet private weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var corneredBackgroundView: UIView!
    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var valueChanged:((_ newValue:Bool)->())? = nil

    func set(_ data:TableData.CellData)  {
        titleLabel.text = data.title
        mainDescriptionLabel.isHidden = data.description ?? "" == ""
        mainDescriptionLabel.text = data.description
        print(data.switchCell?.isOn ?? false, " gterfwds")
        switcher.isOn = data.switchCell?.isOn ?? false
        self.valueChanged = data.switchCell?.switched
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        valueChanged?((sender as? UISwitch)?.isOn ?? false)
    }
    
}
