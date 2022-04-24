//
//  GydeWalkthroughPromptView.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 20/02/22.
//

import UIKit

class GydeWalkthroughPromptView: UIView {

    let overlayView = UIView()
    let containerView = UIView()
    let headerLabel = UILabel()
    let headerSubtitleLabel = UILabel()
    
    var dismissBlock: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("GydeWalkthroughPromptView DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.7
        self.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        overlayView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        overlayView.addGestureRecognizer(tap)
        
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = UIColor.white
        containerView.dropShadow()
        self.insertSubview(containerView, aboveSubview: overlayView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: 18)
        headerLabel.textColor = .systemIndigo
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 2
        containerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        headerSubtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        headerSubtitleLabel.textAlignment = .center
        headerSubtitleLabel.numberOfLines = 3
        containerView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerSubtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15).isActive = true
        headerSubtitleLabel.centerXAnchor.constraint(equalTo: headerLabel.centerXAnchor).isActive = true
        headerSubtitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        
        let selectButton = UIButton()
        selectButton.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        selectButton.backgroundColor = .systemIndigo
        selectButton.setTitleColor(UIColor.white, for: .normal)
        selectButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        selectButton.setTitle("Start", for: .normal)
        selectButton.layer.cornerRadius = 15
        containerView.addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        selectButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    // MARK: Actions
    
    @objc func handleTap() {
        dismissBlock?(false)
    }
    
    @objc func selectAction() {
        dismissBlock?(true)
    }
}
