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
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: step.screenName)
                self.gyde.currentViewController = vc
                self.navigationController?.pushViewController(vc, animated: true)
            }
            completion()
        }
    }
}

@IBDesignable class GradientBackgroundView: UIView {
    
    // Enables more convenient access to layer
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    // implement cgcolorgradient in the next section
    
    @IBInspectable var startColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }
    
    @IBInspectable var endColor: UIColor? {
        didSet { gradientLayer.colors = cgColorGradient }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet { gradientLayer.startPoint = startPoint }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0) {
        didSet { gradientLayer.endPoint = endPoint }
    }
    
    // existing code
}

extension GradientBackgroundView {
    // For this implementation, both colors are required to display
    // a gradient. You may want to extend cgColorGradient to support
    // other use cases, like gradients with three or more colors.
    internal var cgColorGradient: [CGColor]? {
        guard let startColor = startColor, let endColor = endColor else {
            return nil
        }
        
        return [startColor.cgColor, endColor.cgColor]
    }
}
