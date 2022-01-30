//
//  Appdata.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 29/01/22.
//

import Foundation

public class AppData {
    
    /// Singleton
    public static let sharedInstance = AppData()
    
    var currentLanguage: String = "English"
    
    func setLanguage(language: String) {
        self.currentLanguage = language
    }
}
