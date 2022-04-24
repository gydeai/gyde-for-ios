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
        containerView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        let headerLabel = UILabel()
        headerLabel.text = "Select your preferred language"
        headerLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        containerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        let selectButton = UIButton()
        selectButton.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        selectButton.backgroundColor = .systemIndigo
        selectButton.setTitleColor(UIColor.white, for: .normal)
        selectButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        selectButton.setTitle("Select", for: .normal)
        selectButton.layer.cornerRadius = 15
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(selectButton)
        selectButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        selectButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 60).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.backgroundColor = .white
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(UIColor.systemIndigo, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemIndigo.cgColor
        containerView.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -60).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        tableView.register(GydeLanguageSelectorCell.self, forCellReuseIdentifier: "GydeLanguageSelectorCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
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
