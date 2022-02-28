//
//  GydeWebViewController.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 05/02/22.
//

import UIKit
import WebKit

class GydeWebViewController: UIViewController {
    
    var urlString: String!
    var titleString: String!
    
    let headerView = UIView()
    let headerTitleLabel = UILabel()
    let headerButton = UIButton()
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.backgroundColor = AppData.sharedInstance.headerColor
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(80)
        }
        
        headerView.addSubview(headerButton)
        headerButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        headerButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        headerButton.tintColor = AppData.sharedInstance.headerTextColor
        headerButton.snp.makeConstraints { make in
            make.left.equalTo(headerView).offset(10)
            make.centerY.equalTo(headerView)
            make.width.height.equalTo(30)
        }
        
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.textColor = AppData.sharedInstance.headerTextColor
        headerTitleLabel.text = titleString
        headerTitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        headerTitleLabel.adjustsFontSizeToFitWidth = true
        headerTitleLabel.minimumScaleFactor = 0.5
        headerTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(headerButton.snp.right).offset(10)
            make.right.equalTo(headerView).offset(-10)
            make.centerY.equalTo(headerView)
        }

        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }

}

extension GydeWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       print("didFinish")
   }
}
