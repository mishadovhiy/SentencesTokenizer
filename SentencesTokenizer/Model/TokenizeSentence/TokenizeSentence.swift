//
//  TockenizeSentence.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 13.01.2024.
//

import Foundation

struct TokenizeSentence {

    private var lastPosition:Int = 0
    var languageCode:String = ""
    var ignoreDotte:Bool = false
    
    mutating func tokenize(_ string:String) -> [String] {
        self.lastPosition = 0
        if string == "" {
            return []
        } else {
            self.languageCode = DetectLanguage.detect(for: string) ?? ""
            print(languageCode, " languageCodelanguageCode")
            var result = prepareEnteredValue(string)
            WordSeparetor.allValues.forEach({
                result = divideToSentences(result, wordSeparetor: $0)
            })
            return prepareResult(result)
        }
    }
    
    private func prepareResult(_ results:String) -> [String] {
        return results.components(separatedBy: tokenizerSeparetor).compactMap({
            $0.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: tokenizerSeparetor, with: ".")})
    }
    
    mutating private func divideToSentences(_ string:String, wordSeparetor:WordSeparetor) -> String {
        let separetor = wordSeparetor.string(languageCode)
        let range = string.range(of: " \(separetor) ")
        guard let range else {
            return string
        }
        let position = string.distance(from: string.startIndex, to: range.lowerBound)
        if lastPosition == position {
            return string
        }
        self.lastPosition = position
        let last = lastWord(string, position: position)
        var capitalized = string.replacingOccurrences(of: " \(separetor) ", with: " \(separetor.capitalized) ", range: range)

        if last?.string != "." {
            capitalized.insert(contentsOf: tokenizerSeparetor, at: capitalized.index(capitalized.startIndex, offsetBy: last?.position ?? 0))
            
            return divideToSentences(capitalized, wordSeparetor: wordSeparetor)
        }
        return divideToSentences(capitalized, wordSeparetor: wordSeparetor)
    }
        
    private func prepareEnteredValue(_ string:String) -> String {
        var result = string
        let isAppearcased = [true, false]
        isAppearcased.forEach({ isAppearcase in
            WordSeparetor.allValues.forEach({
                let word = $0.string(languageCode)
                let text = isAppearcase ? word.uppercased() : word.capitalized
                result = result.replacingOccurrences(of: " " + text + " ", with: " " + word + " ")
            })
        })
        return result
    }

    private func lastWord(_ string:String, position:Int) -> LastWordResult? {
        let lastIndex = string.index(string.startIndex, offsetBy: position)
        let substring = string.prefix(upTo:lastIndex).last
        if let character = substring,
            substring != " " {
            return .init(position: position, string: String(character))
        } else if substring == nil || position <= 0 {
            return nil
        } else {
            return lastWord(string, position: position - 1)
        }
    }
}


fileprivate extension TokenizeSentence {
    var tokenizerSeparetor:String {
        return ignoreDotte ? ".\n*\n*\n*." : "."
    }
}


extension TokenizeSentence {
    struct LastWordResult {
        let position:Int
        let string:String
    }
    
    enum WordSeparetor:String {
        case and, `if`
        static var allValues:[Self] = [.and, .if]
        
        func string(_ language:String) -> String {
            return rawValue.localize(language)
        }
    }    
}
