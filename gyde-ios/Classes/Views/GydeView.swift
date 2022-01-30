//
//  GydeView.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 25/01/22.
//

import UIKit
import SnapKit

public class GydeView: UIView {
    
    var contentList: ContentList! {
        didSet {
            if let contentList = contentList {
                updateUI(list: contentList)
            }
        }
    }
    
    let headerView = UIView()
    let headerTitleLabel = UILabel()
    let headerSubtitleLabel = UILabel()
    let headerButton = UIButton()
    let segmentedControl = UISegmentedControl()
    let searchHeaderView = UIView()
    let searchTextField = TextFieldWithPadding()
    let tableView = UITableView()
    
    var filteredWalkthroughs = [Walkthrough]()
    var filteredHelpArticles = [HelpArticles]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("GYDE VIEW DEINIT")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func updateUI(list: ContentList) {
        headerView.backgroundColor = hexStringToUIColor(hex: list.headerColor)
        headerTitleLabel.text = list.welcomeGreeting
        headerTitleLabel.textColor = hexStringToUIColor(hex: list.headerTextColor)
        headerSubtitleLabel.text = list.appName
        headerSubtitleLabel.textColor = hexStringToUIColor(hex: list.headerTextColor)
        headerButton.tintColor = hexStringToUIColor(hex: list.headerTextColor)
        segmentedControl.insertSegment(withTitle: list.walkthroughTabText, at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: list.helpArticlesTabText, at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        
        filteredWalkthroughs = contentList.currentLanguageWalkthroughs()
        filteredHelpArticles = contentList.currentHelpArticles()
    }
    
    private func setupViews() {
        addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalTo(self)
            make.height.equalTo(80)
        }
        
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        headerTitleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(headerView).offset(15)
        }
        
        headerView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        headerSubtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(headerTitleLabel)
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(5)
        }
        
        headerView.addSubview(headerButton)
        headerButton.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        headerButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        headerButton.addTarget(self, action: #selector(headerButtonAction), for: .touchUpInside)
        headerButton.snp.makeConstraints { make in
            make.right.equalTo(headerView).offset(-15)
            make.centerY.equalTo(headerSubtitleLabel)
            make.width.height.equalTo(30)
        }
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        self.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(headerView.snp.bottom).offset(2)
            make.height.equalTo(40)
        }
        
        searchHeaderView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        searchHeaderView.layer.cornerRadius = 8
        self.addSubview(searchHeaderView)
        searchHeaderView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(50)
        }
        
        let searchImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        searchImageView.tintColor = UIColor.darkGray
        searchHeaderView.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.leftViewMode = .always
        searchTextField.leftView = searchImageView
        searchTextField.autocapitalizationType = .none
        searchTextField.snp.makeConstraints { make in
            make.right.top.bottom.equalTo(searchHeaderView)
            make.left.equalTo(searchHeaderView).offset(10)
        }
        
        tableView.register(GydeCell.self, forCellReuseIdentifier: "GydeCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(searchHeaderView.snp.bottom).offset(10)
        }
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    // MARK: Actions
    
    @objc func segmentChanged() {
        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = nil
        filteredWalkthroughs = contentList.currentLanguageWalkthroughs()
        filteredHelpArticles = contentList.currentHelpArticles()
        self.tableView.reloadData()
    }
    
    @objc func headerButtonAction() {
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        
        self.filteredWalkthroughs = text.count >= 2 ? self.contentList.currentLanguageWalkthroughs().filter { $0.flowName.lowercased().contains(text) } : contentList.currentLanguageWalkthroughs()
        self.tableView.reloadData()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 5,
        left: 10,
        bottom: 5,
        right: 10
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

extension GydeView: UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension GydeView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return self.filteredWalkthroughs.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return self.filteredHelpArticles.count
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GydeCell", for: indexPath) as? GydeCell else {
            return UITableViewCell()
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.updateWalkthroughs(walkthrough: self.filteredWalkthroughs[indexPath.row])
        } else if segmentedControl.selectedSegmentIndex == 1 {
            cell.updateHelpArticles(helpArticles: self.filteredHelpArticles[indexPath.row])
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
