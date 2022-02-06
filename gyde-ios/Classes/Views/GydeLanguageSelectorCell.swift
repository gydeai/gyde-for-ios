//
//  GydeLanguageSelectorCell.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 06/02/22.
//

import UIKit

class GydeLanguageSelectorCell: UITableViewCell {
    
    let selectedButton = UIButton()
    let selectedView = UIView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        selectedButton.layer.cornerRadius = 10
        selectedButton.layer.borderWidth = 1
        selectedButton.layer.borderColor = UIColor.lightGray.cgColor
        selectedButton.isUserInteractionEnabled = false
        contentView.addSubview(selectedButton)
        selectedButton.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(25)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(20)
        }
        
        selectedView.backgroundColor = UIColor.purple
        selectedView.alpha = 0
        selectedView.layer.cornerRadius = 5
        selectedView.isUserInteractionEnabled = false
        selectedButton.addSubview(selectedView)
        selectedView.snp.makeConstraints { make in
            make.center.equalTo(selectedButton)
            make.width.height.equalTo(10)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(selectedButton.snp.right).offset(15)
            make.centerY.equalTo(selectedButton)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        selectedView.alpha = 0
        selectedButton.layer.borderColor = UIColor.lightGray.cgColor
    }
}
