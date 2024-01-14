//
//  TableData.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import Foundation
import UIKit

struct TableData {
    
    let title:String
    var sectionImage:String? = nil
    
    var needFooter:Bool = true
    var cornerSection:Bool = false
    var sectionPressed:(()->())?
    let tableData:[CellData]
    var needSeparetor:Bool = false
    
    var additionalButton:SectionButton? = nil
    
    struct SectionButton {
        let title:String
        let pressed:()->()
    }
    
    struct CellData {
        
        var title:String
        var description:String? = nil
        
        var image:String? = nil
        var isTextView:Bool = false
        
        var didSelect:((_ cell:UITableViewCell)->())? = nil
        var switchCell:SwitchCell? = nil
        
        var isClear:Bool = false
        
        struct SwitchCell {
            let isOn:Bool
            var switched:(_ isOn:Bool)->()
        }
        
    }
}
