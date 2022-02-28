//
//  Steps.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 16/01/22.
//

import Foundation

public struct Steps: Encodable, Decodable {
    public let title: String
    public let content: String
    public let stepDescription: Int
    public let screenName: String
    public let placement: String
    public let gyClickFlag: Bool
    public let tag: Int?
    public let frame: String
    public let scrollTo: String
    public let gyDelay: String
    public let voiceOverPath: String
    public let voiceOverContent: String
    public let viewId: String
}
