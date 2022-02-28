//
//  GydeLanguageSelectorView.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 06/02/22.
//

import UIKit

class GydeLanguageSelectorView: UIView {

    let overlayView = UIView()
    let containerView = UIView()
    let tableView = UITableView()
    
    var contentList: ContentList! {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var dismissBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("GydeLanguageSelectorView DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
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
            make.height.equalTo(360)
        }
        
        let headerLabel = UILabel()
        headerLabel.text = "Select your preferred language"
        headerLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        containerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(15)
            make.centerX.equalTo(containerView)
        }

        let selectButton = UIButton()
        selectButton.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        selectButton.backgroundColor = .systemIndigo
        selectButton.setTitleColor(UIColor.white, for: .normal)
        selectButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        selectButton.setTitle("Select", for: .normal)
        selectButton.layer.cornerRadius = 15
        containerView.addSubview(selectButton)
        selectButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView).offset(-15)
            make.centerX.equalTo(containerView).offset(60)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }

        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.backgroundColor = .white
        cancelButton.setTitleColor(UIColor.systemIndigo, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemIndigo.cgColor
        containerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(containerView).offset(-15)
            make.centerX.equalTo(containerView).offset(-60)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }

        tableView.register(GydeLanguageSelectorCell.self, forCellReuseIdentifier: "GydeLanguageSelectorCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalTo(containerView)
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
        }
    }
    
    @objc func selectAction() {
        AppData.sharedInstance.currentLanguage = self.contentList.languageOptions[self.selectedIndexPath.row]
        dismissBlock?()
    }
    
    @objc func cancelAction() {
        dismissBlock?()
    }
    
    @objc func handleTap() {
        dismissBlock?()
    }
}

extension GydeLanguageSelectorView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentList.languageOptions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GydeLanguageSelectorCell", for: indexPath) as? GydeLanguageSelectorCell else {
            return UITableViewCell()
        }
        
        cell.selectedView.alpha = self.selectedIndexPath == indexPath ? 1 : 0
        cell.selectedButton.layer.borderColor = self.selectedIndexPath == indexPath ? UIColor.systemIndigo.cgColor : UIColor.lightGray.cgColor
        cell.titleLabel.text = self.contentList.languageOptions[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        tableView.reloadData()
    }
}
