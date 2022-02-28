//
//  AddNewCandidateViewController.swift
//  gyde-ios_Example
//
//  Created by Rushikesh Kulkarni on 27/02/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class AddNewCandidateViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = 6
        
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = UIColor.systemIndigo
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(self.view).offset(40)
        }
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
