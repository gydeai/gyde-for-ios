//
//  Gyde.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 09/01/22.
//

import Foundation

public class Gyde {
    
    private var contentList: ContentList?
    
    private var sdkBundle: Bundle {
        let framework = Bundle(for: Gyde.self)
        return Bundle(url: framework.url(forResource: "gyde-ios",
                                         withExtension: "bundle")!)!
    }
        
    /// Singleton
    public static let sharedInstance = Gyde()
    
    private init() {}
    
    // MARK:- Public
    
    public func setup(appId: String, completion: @escaping (Error?) -> Void) {
        
        // Get Content List
        getContentList(appId: appId) { [weak self] list in
            var error: Error? = nil
            guard let list = list else {
                error = GydeError.NoList
                completion(error)
                return
            }
            
            print(list)
            self?.contentList = list
            completion(nil)
            
        }
        
//        // Get Button Flow
//        getButtonFlow(appId: id, flowId: "95e3d296-0be6-4bfb-8d71-0d7c1b17c40c") { flow in
//            print("Flow \(flow)")
//        }
    }
    
    public func startWidget(mainVC: UIViewController) {
        
        guard let list = contentList else {
            return
        }
        
        let vc = GydeSDKWidgetViewController()
        vc.contentList = list
        mainVC.present(vc, animated: true, completion: nil)
    }
    
    // MARK:- Internal
    
    func getContentList(appId: String, completion: @escaping (ContentList?) -> Void) {
        let url = URL(string: "https://stage-app.gyde.ai/android/getContentList")!
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
                        if let content = try? JSONDecoder().decode(ContentList.self, from: data) {
                            print(content)
                            completion(content)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        print(error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }.resume()
    }
    
    func getButtonFlow(appId: String, flowId: String, completion: @escaping (Flow?) -> Void) {
        let url = URL(string: "https://stage-app.gyde.ai/android/getFlowJsonForBtn")!
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
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        if let flow = try? JSONDecoder().decode(Flow.self, from: data) {
                            print(flow)
                            completion(flow)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        print(error)
                        completion(nil)
                    }
                }
            }.resume()
    }
    
}

public enum GydeError : Error {
    case NoList
}
