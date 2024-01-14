//
//  DetectLanguageString.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 13.01.2024.
//

import Foundation
import NaturalLanguage

struct DetectLanguage {
    static func detect(for string: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        if Localization.dict.keys.contains(languageCode) {
            print(languageCode, " atfredfr")
            return languageCode
        } else {
            print(languageCode, " notcontaints")
            return nil
        }
    }
}
