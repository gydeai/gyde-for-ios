//
//  Flow.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 16/01/22.
//

import Foundation

public struct Flow: Encodable, Decodable {
    let _id: String
    let flowId: String
    let appId: String
    let draftMode: Int
    let flowName: String
    let flowInitText: String
    let flowEndText: String
    let flowEndHeaderText: String
    let flowStepNotFoundText: String
    let flowInitTextVoiceOver: String
    let flowInitVoiceOverPath: String
    let walkthroughVideoLink: String
    let selectedLanguage: String
    let videoOnlyFlag: Bool
    let publishToAllDomainsFlag: Bool
    let role: String
    let filter1: String
    let filter2: String
    let filter3: String
    let url: [String]
    let token: String
    let timeStamp: Double
    let steps: [Steps]
}



