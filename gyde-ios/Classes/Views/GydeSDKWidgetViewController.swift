//
//  GydeSDKWidgetViewController.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 25/01/22.
//

import UIKit

class GydeSDKWidgetViewController: UIViewController {
    
    var contentList: ContentList! {
        didSet {
            setup(list: contentList)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func setup(list: ContentList) {
        let gydeView = GydeView()
        gydeView.contentList = list
        self.view.addSubview(gydeView)
        gydeView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
}
