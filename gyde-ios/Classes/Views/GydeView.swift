//
//  GydeView.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 25/01/22.
//

import UIKit
import SnapKit

protocol GydeProtocol: AnyObject {
    func showWalkthrough(walkthrough: Walkthrough)
    func showWebView(helpArticles: HelpArticles)
}

public class GydeView: UIView {
    
    var contentList: ContentList! {
        didSet {
            if let contentList = contentList {
                updateUI(list: contentList)
            }
        }
    }
    
    fileprivate var sdkBundle: Bundle {
        let framework = Bundle(for: Gyde.self)
        return Bundle(url: framework.url(forResource: "gyde-ios",
                                         withExtension: "bundle")!)!
    }
    
    weak var delegate: GydeProtocol?
    
    let headerView = UIView()
    let headerTitleLabel = UILabel()
    let headerSubtitleLabel = UILabel()
    let headerButton = UIButton()
    let segmentedControl = UISegmentedControl()
    let searchHeaderView = UIView()
    let searchTextField = TextFieldWithPadding()
    let tableView = UITableView()
    let languageSelectorButton = UIButton()
    let languageSelectorView = GydeLanguageSelectorView()
    let walkthroughPromptView = GydeWalkthroughPromptView()
    
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
        languageSelectorView.contentList = list
        
        AppData.sharedInstance.headerColor = headerView.backgroundColor
        AppData.sharedInstance.headerTextColor = headerTitleLabel.textColor
        
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
        headerTitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        headerTitleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(headerView).offset(15)
        }
        
        headerView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        headerSubtitleLabel.snp.makeConstraints { make in
            make.left.equalTo(headerTitleLabel)
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(5)
        }
        
        headerView.addSubview(headerButton)
        headerButton.setImage(UIImage(named: "dots", in: self.sdkBundle, compatibleWith: nil), for: .normal)
        headerButton.addTarget(self, action: #selector(headerButtonAction), for: .touchUpInside)
        headerButton.snp.makeConstraints { make in
            make.right.equalTo(headerView).offset(-15)
            make.centerY.equalTo(headerSubtitleLabel)
            make.width.height.equalTo(24)
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
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(searchHeaderView.snp.bottom).offset(10)
        }
        
        languageSelectorButton.dropShadow()
        languageSelectorButton.alpha = 0
        languageSelectorButton.backgroundColor = .white
        languageSelectorButton.layer.cornerRadius = 4
        languageSelectorButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        languageSelectorButton.setTitleColor(.black, for: .normal)
        languageSelectorButton.setTitle("Select Language", for: .normal)
        languageSelectorButton.addTarget(self, action: #selector(languageSelection), for: .touchUpInside)
        self.addSubview(languageSelectorButton)
        languageSelectorButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-5)
            make.width.equalTo(180)
            make.height.equalTo(50)
            make.top.equalTo(headerView.snp.bottom).offset(-10)
        }
        
        languageSelectorView.alpha = 0
        self.addSubview(languageSelectorView)
        languageSelectorView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        
        languageSelectorView.dismissBlock = { [unowned self] in
            self.filteredWalkthroughs = contentList.currentLanguageWalkthroughs()
            self.filteredHelpArticles = contentList.currentHelpArticles()
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.33) {
                self.languageSelectorView.alpha = 0
            }
        }
        
        walkthroughPromptView.alpha = 0
        self.addSubview(walkthroughPromptView)
        walkthroughPromptView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        let poweredByLabel = UILabel()
        poweredByLabel.font = UIFont(name: "AvenirNext-Medium", size: 13)
        poweredByLabel.text = "Powered by"
        poweredByLabel.textColor = .darkText
        self.addSubview(poweredByLabel)
        poweredByLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-30)
        }
        
        let poweredByGydeImageView = UIImageView()
        poweredByGydeImageView.image = UIImage(named: "gyde-mini-logo", in: self.sdkBundle, compatibleWith: nil)
        poweredByGydeImageView.contentMode = .scaleAspectFit
        self.addSubview(poweredByGydeImageView)
        poweredByGydeImageView.snp.makeConstraints { make in
            make.centerY.equalTo(poweredByLabel)
            make.right.equalTo(poweredByLabel.snp.left).offset(-2)
            make.width.height.equalTo(30)
        }
        
        let gydeFooterLabel = UILabel()
        gydeFooterLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        gydeFooterLabel.text = "Gyde"
        gydeFooterLabel.textColor = .systemIndigo
        self.addSubview(gydeFooterLabel)
        gydeFooterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(poweredByLabel)
            make.left.equalTo(poweredByLabel.snp.right).offset(3)
        }
    }
    
    // MARK: Actions
    
    @objc func languageSelection() {
        self.languageSelectorButton.isSelected = false
        UIView.animate(withDuration: 0.33) {
            self.languageSelectorButton.alpha = 0
            self.languageSelectorView.alpha = 1
        }
    }
    
    @objc func segmentChanged() {
        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = nil
        filteredWalkthroughs = contentList.currentLanguageWalkthroughs()
        filteredHelpArticles = contentList.currentHelpArticles()
        self.tableView.reloadData()
    }
    
    @objc func headerButtonAction() {
        self.languageSelectorButton.isSelected = !self.languageSelectorButton.isSelected
        UIView.animate(withDuration: 0.33) {
            self.languageSelectorButton.alpha = self.languageSelectorButton.isSelected ? 1 : 0
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        guard let text = textField.text else {
            return
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            self.filteredWalkthroughs = text.count >= 2 ? self.contentList.currentLanguageWalkthroughs().filter { $0.flowName.lowercased().contains(text) } : contentList.currentLanguageWalkthroughs()
        } else {
            self.filteredHelpArticles = text.count >= 2 ? self.contentList.currentHelpArticles().filter { $0.question.lowercased().contains(text) } : contentList.currentHelpArticles()
        }
        
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
        
            let selectedWalkthrough = self.filteredWalkthroughs[indexPath.row]
            // API call for button flow
            Gyde.sharedInstance.getButtonFlow(appId: Gyde.sharedInstance.appId, flowId: selectedWalkthrough.flowId) { [unowned self] flow in
                DispatchQueue.main.async {
                    self.walkthroughPromptView.headerLabel.text = flow?.flowName
                    self.walkthroughPromptView.headerSubtitleLabel.text = flow?.flowInitText
                    UIView.animate(withDuration: 0.33) {
                        self.walkthroughPromptView.alpha = 1
                    }
                }
            }

            walkthroughPromptView.dismissBlock = { [unowned self] shouldDismiss in
                UIView.animate(withDuration: 0.33) {
                    self.walkthroughPromptView.alpha = 0
                } completion: { _ in
                    if shouldDismiss {
                        self.delegate?.showWalkthrough(walkthrough: self.filteredWalkthroughs[indexPath.row])
                    }
                }
            }
        } else {
            // Show the webview
            self.delegate?.showWebView(helpArticles: self.filteredHelpArticles[indexPath.row])
        }
    }
}
