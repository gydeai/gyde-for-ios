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
    
    var walkthroughStart: ((String) -> Void?)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func setup(list: ContentList) {
        let gydeView = GydeView()
        gydeView.delegate = self
        gydeView.contentList = list
        gydeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gydeView)
        gydeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        gydeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        gydeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        gydeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension GydeSDKWidgetViewController: GydeProtocol {
    
    func showWalkthrough(walkthrough: Walkthrough) {
        dismiss(animated: true) { [unowned self] in
            self.walkthroughStart?(walkthrough.flowId)
        }
    }
    
    func showWebView(helpArticles: HelpArticles) {
        let vc = GydeWebViewController()
        vc.urlString = helpArticles.urlForMobileWebView
        vc.titleString = helpArticles.question
        self.present(vc, animated: true, completion: nil)
    }
}
