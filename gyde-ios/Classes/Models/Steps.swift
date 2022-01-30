//
//  Steps.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 16/01/22.
//

import Foundation

public struct Steps: Encodable, Decodable {
    let title: String
    let content: String
    let stepDescription: Int
    let screenName: String
    let placement: String
    let gyClickFlag: Bool
    let frame: String
    let scrollTo: String
    let gyDelay: String
    let voiceOverPath: String
    let voiceOverContent: String
    let viewId: String
}
