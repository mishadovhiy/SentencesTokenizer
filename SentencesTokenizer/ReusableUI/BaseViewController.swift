//
//  BaseViewController.swift
//  SentencesTokenizer
//
//  Created by Misha Dovhiy on 14.01.2024.
//

import UIKit

class BaseViewController:UIViewController {
    
    func reloadData(force:Bool = false) {
        
    }
    
    func vibrate() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}
