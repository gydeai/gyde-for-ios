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
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        headerView.addSubview(headerButton)
        headerButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        headerButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        headerButton.tintColor = AppData.sharedInstance.headerTextColor
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10).isActive = true
        headerButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        headerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.textColor = AppData.sharedInstance.headerTextColor
        headerTitleLabel.text = titleString
        headerTitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        headerTitleLabel.adjustsFontSizeToFitWidth = true
        headerTitleLabel.minimumScaleFactor = 0.5
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.leftAnchor.constraint(equalTo: headerButton.rightAnchor, constant: 10).isActive = true
        headerTitleLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10).isActive = true
        headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true

        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        if let encodedURL = urlString.getCleanedURL() {
            let urlRequest = URLRequest(url: encodedURL)
            webView.load(urlRequest)
        } else {
           print("invalid url ")
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

extension String {
 func getCleanedURL() -> URL? {
    guard self.isEmpty == false else {
        return nil
    }
    if let url = URL(string: self) {
        return url
    } else {
        if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
            return escapedURL
        }
    }
    return nil
 }
}
