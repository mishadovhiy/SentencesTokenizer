//
//  Localization.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 13.01.2024.
//

import Foundation

struct Localization {
    static var dict:[String:[String:String]] = [
        "uk":ua.dict,
        "en":eng.dict,
        "it":it.dict,
        "ja":ja.dict,
        "ko":ko.dict,
        "lv":lv.dict,
        "nl":nl.dict,
        "pl":pl.dict,
        "ro":ro.dict,
        "ru":ru.dict,
        "sk":sk.dict,
        "sl":sl.dict,
        "sq":sq.dict,
        "sv":sv.dict,
        "sw":sw.dict,
        "tr":tr.dict,
        "zh":zh.dict,
        "cs":cs.dict,
        "da":da.dict,
        "el":el.dict,
        "et":et.dict,
        "hy":hy.dict,
        "es":es.dict,
        "fr":fr.dict
    ]
    
    static func emoji(for languageCode: String) -> String? {
        if let code = dict[languageCode]?[flagKey] as? String {
            return code
        }
        let base: UInt32 = 127397
        let joined = "///*//"
        let emojiString = languageCode.uppercased().unicodeScalars.compactMap({
            let scalarValue = $0.value
            return String(UnicodeScalar(base + scalarValue)!) + joined
        }).joined(separator: joined).replacingOccurrences(of: joined, with: "")
        return emojiString
    }
    
    static let flagKey = "flag_code"
}


protocol LocaliationProtocol {
    static var dict:[String:String] {get}
}
