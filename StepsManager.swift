//
//  StepsManager.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 25/02/22.
//

import Foundation

protocol StepsDelegate {
    func executeStep(_ step: Steps)
}

class StepsManager {

    var delegate: StepsDelegate? {
        didSet {
            executeFlow()
        }
    }
    
    var steps = [Steps]()

    init(steps: [Steps]) {
        self.steps = steps
    }
    
    func executeFlow() {
        if let step = steps.first, let delegate = self.delegate {
            delegate.executeStep(step)
        }
    }
}
