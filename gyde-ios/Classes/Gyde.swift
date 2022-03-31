//
//  Gyde.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 09/01/22.
//

import Foundation

public protocol GydeDelegate: AnyObject {
    func navigate(step: Steps, completion: @escaping () -> Void)
}

public class Gyde {
    
    private var contentList: ContentList?
    
    ///stage-app.gyde.ai:- Staging
    ///app.gyde.ai:- Prod
    private var baseURL = "app.gyde.ai"
    
    public var currentViewController: UIViewController?
    
    private var sdkBundle: Bundle {
        let framework = Bundle(for: Gyde.self)
        return Bundle(url: framework.url(forResource: "gyde-ios",
                                         withExtension: "bundle")!)!
    }
        
    /// Singleton
    public static let sharedInstance = Gyde()
    
    public weak var delegate: GydeDelegate?
    
    var appId: String!
    
    var steps: StepsManager?
    
    private init() {}
    
    // MARK: Public
    
    public func setup(appId: String, completion: @escaping (Error?) -> Void) {
        
        self.appId = appId
        
        // Get Content List
        getContentList(appId: appId) { [weak self] list in
            var error: Error? = nil
            guard let list = list else {
                error = GydeError.NoList
                completion(error)
                return
            }
            
            print(list)
            print("LOADED")
            self?.contentList = list
            completion(nil)
            
        }
    }
    
    public func startWidget(mainVC: UIViewController) {
        self.currentViewController = mainVC
        guard let list = contentList else {
            return
        }
        
        let vc = GydeSDKWidgetViewController()
        vc.contentList = list
        vc.walkthroughStart = { [unowned self] flowId in
            self.executeButtonFlow(flowId: flowId)
        }
        mainVC.present(vc, animated: true, completion: nil)
    }
    
    public func executeButtonFlow(flowId: String) {
        // Get Button Flow
        self.getButtonFlow(appId: appId, flowId: flowId) { flow in
            guard let flow = flow else {
                return
            }

            self.steps = StepsManager(steps: flow.steps)
            self.steps?.delegate = self
        }
    }
    
    // MARK: Internal
    
    func getContentList(appId: String, completion: @escaping (ContentList?) -> Void) {
        let url = URL(string: "https://\(baseURL)/android/getContentList")!
        let parameterDictionary = ["appId": appId]
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: [.prettyPrinted]) else {
            completion(nil)
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let content = try JSONDecoder().decode(ContentList.self, from: data)
                        completion(content)
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }.resume()
    }
    
    func getButtonFlow(appId: String, flowId: String, completion: @escaping (Flow?) -> Void) {
        let url = URL(string: "https://\(baseURL)/android/getFlowJsonForBtn")!
        let parameterDictionary = ["appId": appId, "flowId": flowId]
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: [.prettyPrinted]) else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let flow = try JSONDecoder().decode(Flow.self, from: data)
                        completion(flow)
                    } catch {
                        completion(nil)
                    }
                }
            }.resume()
    }
    
}

public enum GydeError : Error {
    case NoList
}

enum StepDescription: Int {
    case showToolTip = 1
    case newScreen = 2
    case drawerMenu = 3
    case newTab = 4
}

extension Gyde: StepsDelegate {
    
    func executeStep(_ step: Steps) {
        
        if step.stepDescription == StepDescription.showToolTip.rawValue {
            if let vc = self.currentViewController, let tag = step.tag, let view = vc.view.viewWithTag(tag) {
                var calloutView: GydeCalloutView?
                calloutView = GydeCalloutView(currentFrame: view.frame, step: step)
                calloutView?.lastStep = self.steps?.count == 1
                vc.view.addSubview(calloutView!)
                calloutView?.snp.makeConstraints { make in
                    make.left.right.top.bottom.equalTo(vc.view)
                }
                
                // When tapped on the next button
                calloutView?.nextCallback = {
                    UIView.animate(withDuration: 0.33) {
                        calloutView?.triangleView.alpha = 0
                        calloutView?.containerView.alpha = 0
                    } completion: { _ in
                        calloutView?.removeFromSuperview()
                        calloutView = nil
                        self.steps?.steps.removeFirst()
                        self.steps?.count -= 1
                        self.steps?.executeFlow()
                    }
                }
                
                // When tapped on the close button
                calloutView?.closeCallback = {
                    UIView.animate(withDuration: 0.33) {
                        calloutView?.triangleView.alpha = 0
                        calloutView?.containerView.alpha = 0
                    } completion: { _ in
                        calloutView?.removeFromSuperview()
                        calloutView = nil
                        self.steps?.steps.removeAll()
                        self.steps?.count = 0
                    }
                }
                
            }
        } else if step.stepDescription == StepDescription.newScreen.rawValue {
            self.delegate?.navigate(step: step, completion: {
                self.steps?.steps.removeFirst()
                self.steps?.executeFlow()
            })
        }
    }
}
