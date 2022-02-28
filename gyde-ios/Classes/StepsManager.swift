//
//  StepsManager.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 25/02/22.
//

import Foundation

protocol StepsDelegate: AnyObject {
    func executeStep(_ step: Steps)
}

class StepsManager {

    weak var delegate: StepsDelegate? {
        didSet {
            executeFlow()
        }
    }
    
    var steps = [Steps]()
    var count = 0

    init(steps: [Steps]) {
        self.steps = steps
        for step in steps {
            if step.stepDescription == StepDescription.showToolTip.rawValue {
                count += 1
            }
        }
    }
    
    func executeFlow() {
        if let step = steps.first, let delegate = self.delegate {
            delegate.executeStep(step)
        }
    }
}
