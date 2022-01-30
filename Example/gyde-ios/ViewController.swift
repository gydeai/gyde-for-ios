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

