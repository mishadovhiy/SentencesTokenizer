//
//  TokenizeViewModel.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 13.01.2024.
//

import Foundation
import UIKit

class TokenizeViewModel {
    
    var tokenizer:TokenizeSentence
    
    private var showingSettings = false
    var tokenizedTableData:[String] = []
    var enteredValue:String = "" {
        didSet {
            showingSettings = false
            tokenize()
        }
    }
    
    private var reloadData:(_ force:Bool)->()
    private var endEditing:()->()
    private var copyPressedView:(_ string:String, _ cell:UITableViewCell?)->()
    private var _message:MessageContent?
    let placeHolder:String = "Enter value"
    
    init(reloadData:@escaping(_ force:Bool)->(),
         endEditing:@escaping()->(),
         copyPressed:@escaping(_ string:String, _ cell:UITableViewCell?)->()
    ) {
        self.endEditing = endEditing
        self.reloadData = reloadData
        self.copyPressedView = copyPressed
        self.tokenizer = .init()
        self.tokenize()
    }
    
    public func tokenize() {
        Task {
            let newValue = self.tokenizer.tokenize(self.enteredValue)
          //  let notChanged = newValue.count == self.tokenizedTableData.count
            self.tokenizedTableData = newValue
            await reloadTableData(true)
        }
    }
    
    @MainActor private func reloadTableData(_ force:Bool) {
        self.reloadData(force)
    }
    
    
    //MARK: TableData
    @MainActor var tableData:[TableData] {
        [
            .init(title: !showingSettings ? "" : "Settings", needFooter: showingSettings, cornerSection: true, sectionPressed: toggleSettingsPressed,
                  tableData: settingsSectionData, needSeparetor:false),
            .init(title: messageSectionTitle ?? "| Tokenized \(languageTitle)", sectionImage: "gear", sectionPressed: toggleSettingsPressed, tableData: resultTableData, needSeparetor: true, additionalButton: messageSectionTitle != nil ? nil : .init(title: "Copy", pressed: {
                self.copyPressed(cell: nil)
            }))
        ]
    }
    
    @MainActor private var resultTableData:[TableData.CellData] {
        message != nil ? [.init(title: message?.title ?? "?", isClear: true)] : tokenizedTableData.compactMap({ token in
                .init(title: token, didSelect: {
                    self.copyPressed(at: token, cell: $0)
            })
        })
    }
    
    private var settingsSectionData:[TableData.CellData] {
        !showingSettings ? [] : [
          .init(title: "Separate all new sentences", switchCell: .init(isOn: (DB.holder?.settings.separateAllDottes ?? false), switched: {
              self.andIfSwitchChanged($0)
          }))
        ]
    }
    
    //MARK: pressed
    private func andIfSwitchChanged(_ isOn:Bool) {
        endEditing()
        Task {
            DB.data.settings.separateAllDottes = isOn
            self.tokenizer.ignoreDotte = !DB.data.settings.separateAllDottes

            self.tokenize()
        }
    }
    
    @MainActor private func toggleSettingsPressed() {
        endEditing()
        showingSettings = !showingSettings
        reloadTableData(false)
    }
    
    @MainActor private func copyPressed(at:String? = nil, cell:UITableViewCell?) {
        if let at {
            self.copyPressedView(at, cell)
        } else {
            self.copyPressedView(tokenizedTableData.joined(separator: ".\n"), nil)
        }
    }
    
    //MARK: Other
    private var message:MessageContent? {
        get {
            if tokenizedTableData.count == 0 {
                return .init(title: "Start typing\nkeywords \"and\", \"if\" would be separeted", text: "")
            }
            return _message
        }
        set {
            _message = newValue
        }
    }
    
    private var messageSectionTitle:String? {
        return message == nil ? nil : (tokenizedTableData.count == 0 ? "No data entered" : "Error occupied \(languageTitle)")
    }
    
    private var languageTitle:String {
        let emoji = Localization.emoji(for: tokenizer.languageCode) ?? ""
        return " " + emoji + " (\(tokenizer.languageCode))"
    }
    
    var viewTitle:String {
        return "Tokenizer"
    }
}
