//
//  ViewController.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 01/09/2022.
//  Copyright (c) 2022 Rushikesh Kulkarni. All rights reserved.
//

import UIKit
import gyde_ios

class ViewController: UIViewController {
    
    @IBOutlet weak var addNewCandidateButton: UIButton!
    @IBOutlet weak var applicationsButton: UIButton!
    @IBOutlet weak var selectedCandidatesButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    let gyde = Gyde.sharedInstance
    
    let appId = "7aefb676-4ca2-4087-b360-274710b0411e"
    
    var loaded = false {
        didSet {
            DispatchQueue.main.async {
                self.helpButton.alpha = self.loaded ? 1 : 0.5
                self.helpButton.isUserInteractionEnabled = self.loaded
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNewCandidateButton.layer.cornerRadius = 6
        self.applicationsButton.layer.cornerRadius = 6
        self.selectedCandidatesButton.layer.cornerRadius = 6
        self.helpButton.layer.cornerRadius = 6
        
        self.addNewCandidateButton.tag = 0
        self.applicationsButton.tag = 1
        self.selectedCandidatesButton.tag = 2
        self.helpButton.tag = 3
        
        gyde.delegate = self
        gyde.setup(appId: appId) { error in
            guard error == nil else {
                self.loaded = false
                return
            }
            
            self.loaded = true
            
        }
    }
    
    // MARK:- Actions
    
    @IBAction func addNewCandidateAction(_ sender: UIButton) {
    }
    
    @IBAction func applicationsButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func selectedCandidatesButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func helpAction(_ sender: UIButton) {
        if self.loaded {
            // Start Widget
            gyde.startWidget(mainVC: self)
        }
    }
}

extension ViewController: GydeDelegate {

    func navigate(step: Steps, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            if self.restorationIdentifier == step.screenName {
                // Do nothing as the screen name is this only
                print("Done")
            } else {
                // Navigate
                print("Ok")
            }
            completion()
        }
    }
}
