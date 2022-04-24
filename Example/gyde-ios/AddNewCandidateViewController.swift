//
//  AddNewCandidateViewController.swift
//  gyde-ios_Example
//
//  Created by Rushikesh Kulkarni on 27/02/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class AddNewCandidateViewController: UIViewController {

    @IBOutlet weak var enterCandidateNameTextField: UITextField!
    @IBOutlet weak var enterCandidatePhoneNumberTextField: UITextField!
    @IBOutlet weak var designationTextField: UITextField!
    @IBOutlet weak var resumeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 6
        enterCandidateNameTextField.delegate = self
        enterCandidatePhoneNumberTextField.delegate = self
        designationTextField.delegate = self
        resumeTextField.delegate = self
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = UIColor.systemIndigo
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backButton)
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddNewCandidateViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == resumeTextField {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == resumeTextField {
            UIApplication.shared.open(URL(string:"photos-redirect://")!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
