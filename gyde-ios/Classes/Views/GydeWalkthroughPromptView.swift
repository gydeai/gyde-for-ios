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
        overlayView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        overlayView.addGestureRecognizer(tap)
        
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = UIColor.white
        containerView.dropShadow()
        self.insertSubview(containerView, aboveSubview: overlayView)
        containerView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(200)
        }
        
        headerLabel.font = UIFont(name: "AvenirNext-Bold", size: 18)
        headerLabel.textColor = .systemIndigo
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 0
        containerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(30)
            make.width.equalTo(containerView).multipliedBy(0.9)
            make.centerX.equalTo(containerView)
        }
        
        headerSubtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        headerSubtitleLabel.textAlignment = .center
        headerSubtitleLabel.numberOfLines = 0
        containerView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(15)
            make.centerX.equalTo(headerLabel)
            make.width.equalTo(containerView).multipliedBy(0.9)
        }
        
        let selectButton = UIButton()
        selectButton.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        selectButton.backgroundColor = .systemIndigo
        selectButton.setTitleColor(UIColor.white, for: .normal)
        selectButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        selectButton.setTitle("Start", for: .normal)
        selectButton.layer.cornerRadius = 15
        containerView.addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView).offset(-15)
            make.centerX.equalTo(containerView)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    // MARK: Actions
    
    @objc func handleTap() {
        dismissBlock?(false)
    }
    
    @objc func selectAction() {
        dismissBlock?(true)
    }
}
