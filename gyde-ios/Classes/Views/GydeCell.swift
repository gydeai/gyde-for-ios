//
//  GydeCell.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 29/01/22.
//

import UIKit

class GydeCell: UITableViewCell {
    
    let containerView = UIView()
    
    let titleLabel = UILabel()
    let detailImageView = UIImageView()
    let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        containerView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        containerView.layer.cornerRadius = 4
        contentView.addSubview(containerView)
        containerView.dropShadow()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        
        detailImageView.image = UIImage(systemName: "eye")
        detailImageView.tintColor = UIColor.systemIndigo
        containerView.addSubview(detailImageView)
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        detailImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        detailImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        detailImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        detailImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        subtitleLabel.text = "Guide me"
        subtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 13)
        subtitleLabel.textColor = UIColor.systemIndigo
        containerView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.centerYAnchor.constraint(equalTo: detailImageView.centerYAnchor).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: detailImageView.rightAnchor, constant: 5).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWalkthroughs(walkthrough: Walkthrough) {
        titleLabel.text = walkthrough.flowName
        subtitleLabel.isHidden = false
        detailImageView.isHidden = false
    }
    
    func updateHelpArticles(helpArticles: HelpArticles) {
        titleLabel.text = helpArticles.question
        subtitleLabel.isHidden = true
        detailImageView.isHidden = true
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
