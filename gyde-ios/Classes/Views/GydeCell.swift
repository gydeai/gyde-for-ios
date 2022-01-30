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
        containerView.snp.makeConstraints { make in
            make.left.top.equalTo(self.contentView).offset(10)
            make.right.bottom.equalTo(self.contentView).offset(-10)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(containerView).offset(8)
            make.top.equalTo(containerView).offset(12)
            make.right.equalTo(containerView).offset(-8)
        }
        
        detailImageView.image = UIImage(systemName: "eye")
        detailImageView.tintColor = UIColor.purple
        containerView.addSubview(detailImageView)
        detailImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.width.height.equalTo(15)
        }
        
        subtitleLabel.text = "Guide me"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = UIColor.purple
        containerView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(detailImageView)
            make.left.equalTo(detailImageView.snp.right).offset(5)
            make.bottom.equalTo(containerView).offset(-12)
        }
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
