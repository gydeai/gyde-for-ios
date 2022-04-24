//
//  GydeView.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 25/01/22.
//

import UIKit

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
    let noContentLabel = UILabel()
    
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
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerTitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        headerTitleLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 15).isActive = true
        headerTitleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15).isActive = true
        
        headerView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerSubtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        headerSubtitleLabel.leftAnchor.constraint(equalTo: headerTitleLabel.leftAnchor).isActive = true
        headerSubtitleLabel.topAnchor.constraint(equalTo: headerTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        headerView.addSubview(headerButton)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.setImage(UIImage(named: "dots", in: self.sdkBundle, compatibleWith: nil), for: .normal)
        headerButton.addTarget(self, action: #selector(headerButtonAction), for: .touchUpInside)
        headerButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -15).isActive = true
        headerButton.centerYAnchor.constraint(equalTo: headerSubtitleLabel.centerYAnchor).isActive = true
        headerButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        headerButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        self.addSubview(segmentedControl)
        segmentedControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 2).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchHeaderView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        searchHeaderView.layer.cornerRadius = 8
        searchHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(searchHeaderView)
        searchHeaderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        searchHeaderView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        searchHeaderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        searchHeaderView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let searchImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        searchImageView.tintColor = UIColor.darkGray
        searchHeaderView.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.leftViewMode = .always
        searchTextField.leftView = searchImageView
        searchTextField.autocapitalizationType = .none
        searchTextField.topAnchor.constraint(equalTo: searchHeaderView.topAnchor).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: searchHeaderView.rightAnchor).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: searchHeaderView.bottomAnchor).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: searchHeaderView.leftAnchor, constant: 10).isActive = true
        
        tableView.register(GydeCell.self, forCellReuseIdentifier: "GydeCell")
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchHeaderView.bottomAnchor, constant: 10).isActive = true
        
        languageSelectorButton.dropShadow()
        languageSelectorButton.translatesAutoresizingMaskIntoConstraints = false
        languageSelectorButton.alpha = 0
        languageSelectorButton.backgroundColor = .white
        languageSelectorButton.layer.cornerRadius = 4
        languageSelectorButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 14)
        languageSelectorButton.setTitleColor(.black, for: .normal)
        languageSelectorButton.setTitle("Select Language", for: .normal)
        languageSelectorButton.addTarget(self, action: #selector(languageSelection), for: .touchUpInside)
        self.addSubview(languageSelectorButton)
        languageSelectorButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        languageSelectorButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        languageSelectorButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        languageSelectorButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        languageSelectorView.alpha = 0
        languageSelectorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(languageSelectorView)
        languageSelectorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        languageSelectorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        languageSelectorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        languageSelectorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        noContentLabel.text = "Searched content not available"
        noContentLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        noContentLabel.textColor = UIColor.darkGray
        noContentLabel.alpha = 0
        noContentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(noContentLabel, aboveSubview: tableView)
        noContentLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        noContentLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        languageSelectorView.dismissBlock = { [unowned self] in
            noContentLabel.alpha = 0
            if segmentedControl.selectedSegmentIndex == 0 {
                self.filteredWalkthroughs = contentList.currentLanguageWalkthroughs()
                if !self.filteredWalkthroughs.isEmpty {
                } else {
                    noContentLabel.alpha = 1
                }
                self.tableView.reloadData()
            }
            
            if segmentedControl.selectedSegmentIndex == 1 {
                self.filteredHelpArticles = contentList.currentHelpArticles()
                if !self.filteredHelpArticles.isEmpty {
                } else {
                    noContentLabel.alpha = 1
                }
                self.tableView.reloadData()
            }
            
            UIView.animate(withDuration: 0.33) {
                self.languageSelectorView.alpha = 0
            }
        }
        
        walkthroughPromptView.alpha = 0
        walkthroughPromptView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(walkthroughPromptView)
        walkthroughPromptView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        walkthroughPromptView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        walkthroughPromptView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        walkthroughPromptView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        let poweredByLabel = UILabel()
        poweredByLabel.translatesAutoresizingMaskIntoConstraints = false
        poweredByLabel.font = UIFont(name: "AvenirNext-Medium", size: 13)
        poweredByLabel.text = "Powered by"
        poweredByLabel.textColor = .darkText
        self.addSubview(poweredByLabel)
        poweredByLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        poweredByLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
        
        let poweredByGydeImageView = UIImageView()
        poweredByGydeImageView.translatesAutoresizingMaskIntoConstraints = false
        poweredByGydeImageView.image = UIImage(named: "gyde-mini-logo", in: self.sdkBundle, compatibleWith: nil)
        poweredByGydeImageView.contentMode = .scaleAspectFit
        self.addSubview(poweredByGydeImageView)
        poweredByGydeImageView.centerYAnchor.constraint(equalTo: poweredByLabel.centerYAnchor).isActive = true
        poweredByGydeImageView.rightAnchor.constraint(equalTo: poweredByLabel.leftAnchor, constant: -2).isActive = true
        poweredByGydeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        poweredByGydeImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let gydeFooterLabel = UILabel()
        gydeFooterLabel.translatesAutoresizingMaskIntoConstraints = false
        gydeFooterLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        gydeFooterLabel.text = "Gyde"
        gydeFooterLabel.textColor = .systemIndigo
        self.addSubview(gydeFooterLabel)
        gydeFooterLabel.centerYAnchor.constraint(equalTo: poweredByLabel.centerYAnchor).isActive = true
        gydeFooterLabel.leftAnchor.constraint(equalTo: poweredByLabel.rightAnchor, constant: 3).isActive = true
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
        noContentLabel.alpha = 0
        self.searchTextField.resignFirstResponder()
        self.searchTextField.text = nil
        filteredWalkthroughs = contentList.currentLanguageWalkthroughs()
        filteredHelpArticles = contentList.currentHelpArticles()
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if filteredWalkthroughs.isEmpty {
                noContentLabel.alpha = 1
            }
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            if filteredHelpArticles.isEmpty {
                noContentLabel.alpha = 1
            }
        }
        
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
