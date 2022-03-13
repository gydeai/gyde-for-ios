//
//  GydeCalloutView.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 26/02/22.
//

import UIKit
import AVKit

enum CallOutPosition: String {
    case left
    case right
    case top
    case bottom
    
    case bottomCenter
    case bottomLeft
    case bottomRight
    
    case topLeft
    case topCenter
    case topRight
}

class GydeCalloutView: UIView {
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let audioButton = UIButton()
    let closeButton = UIButton()
    let nextButton = UIButton()
    
    let triangleView = UIView()
    
    var closeCallback: (() -> Void)?
    var nextCallback: (() -> Void)?
    var player: AVAudioPlayer?
    
    var currentFrame: CGRect?
    var position: String?
    var title: String!
    var subtitle: String!
    var audioURL: String?
    
    var lastStep = false {
        didSet {
            nextButton.setTitle(lastStep ? "Done" : "Next", for: .normal)
        }
    }
    
    func getPosition() -> CallOutPosition {
        if let position = position {
            let pos = position.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().replacingOccurrences(of: " ", with: "")
            
            if pos == "bottomcenter" {
                return .bottomCenter
            }
            
            if pos == "bottomleft" {
                return .bottomLeft
            }
            
            if pos == "bottomright" {
                return .bottomRight
            }
            
            if pos == "topcenter" {
                return .topCenter
            }
            
            if pos == "topleft" {
                return .topLeft
            }
            
            if pos == "topright" {
                return .topRight
            }
            
            if pos == "left" {
                return .left
            }
            
            if pos == "right" {
                return .right
            }
            
            if pos == "bottom" {
                return .bottom
            }
            
            if pos == "top" {
                return .top
            }
        }
        return .bottomCenter
    }
    
    init(currentFrame: CGRect, step: Steps) {
        self.currentFrame = currentFrame
        self.title = step.title
        self.subtitle = step.content
        self.position = step.placement
        self.audioURL = step.voiceOverPath
        super.init(frame: .zero)
        setupViews(position: getPosition())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("GYDE CALLOUT VIEW DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self { return nil }
        return result
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if getPosition() == .bottomCenter {
            self.setUpTriangle()
        } else if getPosition() == .topLeft {
            self.setDownTriangle()
        }
    }
    
    func setupViews(position: CallOutPosition) {
        
        guard let currFrame = currentFrame else {
            return
        }

        self.triangleView.alpha = 0
        self.triangleView.backgroundColor = UIColor.clear
        self.addSubview(self.triangleView)
        self.triangleView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            if position == .bottomCenter {
                make.centerX.equalTo(self)
                make.top.equalTo(currFrame.midY)
            } else if position == .topLeft {
                make.left.equalTo(self).offset(currFrame.origin.x)
                make.top.equalTo(currFrame.origin.y)
            }
        }
    
        containerView.layer.cornerRadius = 6
        containerView.alpha = 0
        containerView.backgroundColor = UIColor.white
        containerView.dropShadow()
        self.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.width.equalTo(240)
            if position == .bottomCenter {
                make.centerX.equalTo(self)
                make.top.equalTo(self.triangleView.snp.bottom)
            } else if position == .topLeft {
                make.left.equalTo(self.triangleView)
                make.bottom.equalTo(self.triangleView.snp.top)
            }
        }
        
        titleLabel.text = title
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        titleLabel.textColor = .systemIndigo
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(40)
            make.width.equalTo(containerView).multipliedBy(0.9)
            make.left.equalTo(containerView).offset(15)
        }
        
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        containerView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(titleLabel)
            make.width.equalTo(containerView).multipliedBy(0.9)
        }
        
        closeButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeButton.tintColor = AppData.sharedInstance.headerColor ?? .systemIndigo
        containerView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).offset(-15)
            make.width.height.equalTo(24)
        }
        
        
        audioButton.addTarget(self, action: #selector(audioAction), for: .touchUpInside)
        audioButton.tintColor = AppData.sharedInstance.headerColor ?? .systemIndigo
        audioButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
        audioButton.setImage(UIImage(systemName: "volume.2.fill"), for: .selected)
        containerView.addSubview(audioButton)
        audioButton.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.right.equalTo(closeButton.snp.right).offset(-30)
            make.width.height.equalTo(24)
        }
        
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        nextButton.backgroundColor = .systemIndigo
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 12)
        nextButton.layer.cornerRadius = 15
        containerView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView).offset(-10)
            make.centerX.equalTo(containerView)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        UIView.animate(withDuration: 0.33) {
            self.triangleView.alpha = 1
            self.containerView.alpha = 1
        }
    }
    
    // MARK: Helpers
    
    func setRightTriangle() {
        let heightWidth = triangleView.frame.size.width //you can use triangleView.frame.size.height
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:heightWidth, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth/2, y:heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y:0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = self.containerView.backgroundColor?.cgColor
        
        triangleView.layer.insertSublayer(shape, at: 0)
    }
    
    func setLeftTriangle() {
        let heightWidth = triangleView.frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x:0, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth/2, y:heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y:0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = self.containerView.backgroundColor?.cgColor
        
        triangleView.layer.insertSublayer(shape, at: 0)
    }
    
    func setUpTriangle() {
        let heightWidth = triangleView.frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: heightWidth))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:heightWidth))
        path.addLine(to: CGPoint(x:0, y:heightWidth))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = self.containerView.backgroundColor?.cgColor
        
        triangleView.layer.insertSublayer(shape, at: 0)
    }
    
    func setDownTriangle() {
        let heightWidth = triangleView.frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:heightWidth/2, y: heightWidth/2))
        path.addLine(to: CGPoint(x:heightWidth, y:0))
        path.addLine(to: CGPoint(x:0, y:0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = self.containerView.backgroundColor?.cgColor
        
        triangleView.layer.insertSublayer(shape, at: 0)
    }
    
    // MARK: Actions
    
    @objc func closeAction() {
        self.closeCallback?()
    }
    
    @objc func audioAction() {
        self.audioButton.isSelected = !self.audioButton.isSelected
        
        if self.audioButton.isSelected {
            guard let audioURL = audioURL, let fileURL = URL(string:audioURL) else { return }
            do {
                let soundData = try Data(contentsOf: fileURL)
                self.player = try AVAudioPlayer(data: soundData)
                guard let audioPlayer = player else { return }
                audioPlayer.prepareToPlay()
                audioPlayer.delegate = self
                audioPlayer.volume = 1.0
                audioPlayer.play()
            } catch {
                print(error)
            }
        } else {
            if let player = player {
                player.stop()
            }
        }
    }
    
    @objc func nextAction() {
        self.nextCallback?()
    }
}

extension GydeCalloutView: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioButton.isSelected = false
    }
}
