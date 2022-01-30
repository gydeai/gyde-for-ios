//
//  HelpArticles.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 16/01/22.
//

import Foundation

public struct HelpArticles: Encodable, Decodable {
    let type: String
    let queId: String
    let question: String
    let language: String
    let category: String
    let urlForMobileWebView: String
}
