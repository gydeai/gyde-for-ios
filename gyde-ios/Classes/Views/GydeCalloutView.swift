//
//  GydeCalloutView.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 26/02/22.
//

import UIKit
import AVKit

enum CallOutPosition: String {
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
    
    let calloutWidth = 240
    let calloutHeight = 160
    
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
        if getPosition() == .bottomCenter || getPosition() == .bottomLeft || getPosition() == .bottomRight {
            self.setUpTriangle()
        } else if getPosition() == .topLeft || getPosition() == .topCenter || getPosition() == .topRight {
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
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        triangleView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        triangleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        if position == .bottomCenter {
            triangleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            triangleView.topAnchor.constraint(equalTo: self.topAnchor, constant: currFrame.midY).isActive = true
        } else if position == .bottomLeft {
            triangleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat((calloutWidth / 2) - 10)).isActive = true
            triangleView.topAnchor.constraint(equalTo: self.topAnchor, constant: currFrame.midY).isActive = true
        } else if position == .bottomRight {
            let constant = CGFloat(-(calloutWidth / 2) - 10)
            triangleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: constant).isActive = true
            triangleView.topAnchor.constraint(equalTo: self.topAnchor, constant: currFrame.midY).isActive = true
        } else if position == .topLeft {
            triangleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: currFrame.origin.x).isActive = true
            triangleView.topAnchor.constraint(equalTo: self.topAnchor, constant: currFrame.origin.y).isActive = true
        } else if position == .topCenter {
            triangleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            triangleView.topAnchor.constraint(equalTo: self.topAnchor, constant: currFrame.midY).isActive = true
        } else if position == .topRight {
            triangleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -currFrame.origin.x).isActive = true
            triangleView.topAnchor.constraint(equalTo: self.topAnchor, constant: currFrame.origin.y).isActive = true
        }
    
        containerView.layer.cornerRadius = 6
        containerView.alpha = 0
        containerView.backgroundColor = UIColor.white
        containerView.dropShadow()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)
        containerView.heightAnchor.constraint(equalToConstant: CGFloat(calloutHeight)).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: CGFloat(calloutWidth)).isActive = true
        if position == .bottomCenter {
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: self.triangleView.bottomAnchor).isActive = true
        } else if position == .bottomLeft {
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: self.triangleView.bottomAnchor).isActive = true
        } else if position == .bottomRight {
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            containerView.topAnchor.constraint(equalTo: self.triangleView.bottomAnchor).isActive = true
        } else if position == .topLeft {
            containerView.leftAnchor.constraint(equalTo: self.triangleView.leftAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: self.triangleView.topAnchor).isActive = true
        } else if position == .topCenter {
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: self.triangleView.topAnchor).isActive = true
        } else if position == .topRight {
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            containerView.bottomAnchor.constraint(equalTo: self.triangleView.topAnchor).isActive = true
        }
        
        titleLabel.text = title
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        titleLabel.textColor = .systemIndigo
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15).isActive = true
        
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 12)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.5
        containerView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        subtitleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        
        closeButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        closeButton.tintColor = AppData.sharedInstance.headerColor ?? .systemIndigo
        containerView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        closeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        audioButton.addTarget(self, action: #selector(audioAction), for: .touchUpInside)
        audioButton.tintColor = AppData.sharedInstance.headerColor ?? .systemIndigo
        audioButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
        audioButton.setImage(UIImage(systemName: "volume.2.fill"), for: .selected)
        containerView.addSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        audioButton.rightAnchor.constraint(equalTo: closeButton.rightAnchor, constant: -30).isActive = true
        audioButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        audioButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        nextButton.backgroundColor = .systemIndigo
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 12)
        nextButton.layer.cornerRadius = 15
        containerView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
