//
//  Walkthrough.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 16/01/22.
//

import Foundation

public struct Walkthrough: Encodable, Decodable {
    let type: String
    let flowId: String
    let flowName: String
    let walkthroughVideoLink: String
    let videoOnlyFlag: Bool
    let language: String
}
