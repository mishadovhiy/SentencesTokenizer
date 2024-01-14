//
//  DB.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import Foundation

struct DB {
    
    static var holder:DataBase?
    
    static var data:DataBase {
        get {
            if let holder {
                return holder
            }
            holder = .init(dict: UserDefaults.standard.value(forKey: "DataBase") as? [String:Any] ?? [:])
            return holder ?? .init(dict: [:])
        }
        set {
            holder = newValue
            UserDefaults.standard.setValue(newValue.dict, forKey: "DataBase")
            print(newValue.dict)
        }
    }
}

struct DataBase {
    var dict:[String:Any]
    
    init(dict: [String : Any]) {
        self.dict = dict
    }
    
    var settings:Settings {
        get {
            return .init(dict: dict["Settings"] as? [String:Any] ?? [:])
        }
        set {
            dict.updateValue(newValue.dict, forKey: "Settings")
        }
    }
}


extension DataBase {
    struct Settings {
        var dict:[String:Any]
        
        init(dict: [String : Any]) {
            self.dict = dict
        }
        
        var separateAllDottes:Bool {
            get {
                return dict["separateAll"] as? Int ?? 0 == 1
            }
            set {
                dict.updateValue(newValue ? 1 : 0, forKey: "separateAll")
            }
        }
    }
}
