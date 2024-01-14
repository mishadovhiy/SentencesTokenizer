//
//  String.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 13.01.2024.
//


extension String {
    var localize:String {
        return localize("en")
    }
    
    func localize(_ languageCode:String) -> String {
        return Localization.dict[languageCode]?[self] ?? self
    }
}
