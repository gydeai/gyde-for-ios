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
        selectedButton.translatesAutoresizingMaskIntoConstraints = false
        selectedButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        selectedButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        selectedButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        selectedButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        selectedView.backgroundColor = UIColor.systemIndigo
        selectedView.alpha = 0
        selectedView.layer.cornerRadius = 5
        selectedView.isUserInteractionEnabled = false
        selectedButton.addSubview(selectedView)
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor).isActive = true
        selectedView.centerYAnchor.constraint(equalTo: selectedButton.centerYAnchor).isActive = true
        selectedView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        selectedView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: selectedButton.rightAnchor, constant: 15).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: selectedButton.centerYAnchor).isActive = true
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
