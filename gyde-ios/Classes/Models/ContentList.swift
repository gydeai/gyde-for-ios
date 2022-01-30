//
//  ContentList.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 16/01/22.
//

import Foundation

public struct ContentList: Encodable, Decodable {
    let appName: String
    let welcomeGreeting: String
    let walkthroughTabText: String
    let helpArticlesTabText: String
    let headerColor: String
    let headerTextColor: String
    let btnColor: String
    let languageOptions: [String]
    let uiType: String
    let walkthroughs: [Walkthrough]
    let helpArticles: [HelpArticles]
    
    func currentLanguageWalkthroughs() -> [Walkthrough] {
        return walkthroughs.filter {$0.language ==  AppData.sharedInstance.currentLanguage}
    }
    
    func currentHelpArticles() -> [HelpArticles] {
        return helpArticles.filter {$0.language ==  AppData.sharedInstance.currentLanguage}
    }
}
