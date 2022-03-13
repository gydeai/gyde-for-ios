//
//  AppDelegate.swift
//  gyde-ios
//
//  Created by Rushikesh Kulkarni on 01/09/2022.
//  Copyright (c) 2022 Rushikesh Kulkarni. All rights reserved.
//

import UIKit
import gyde_ios

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loaded = false
    let appId = "7aefb676-4ca2-4087-b360-274710b0411e"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setup { err in
            guard err == nil else {
                print("Error")
                return
            }
            print("Loaded app delegate")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        print("url \(url.components)")
        if let urlComponents = url.components,
            let flowId = urlComponents.queryItems?["flowId"] {
            if !loaded {
                setup { error in
                    guard error == nil else {
                        return
                    }
                    
                    Gyde.sharedInstance.executeButtonFlow(flowId: flowId)
                }
            } else {
                Gyde.sharedInstance.executeButtonFlow(flowId: flowId)
            }
        }
        return true
    }

    func setup(completion: @escaping (Error?) -> Void) {
        Gyde.sharedInstance.delegate = self
        Gyde.sharedInstance.setup(appId: appId) { error in
            guard error == nil else {
                self.loaded = false
                completion(error)
                return
            }
            
            DispatchQueue.main.async {
                self.loaded = true
                if let topViewController = UIApplication.topViewController() {
                    Gyde.sharedInstance.currentViewController = topViewController
                }
                completion(nil)
            }
        }
    }
}

extension URL {
    var components: URLComponents? {
        return URLComponents(url: self, resolvingAgainstBaseURL: false)
    }
}

extension Array where Iterator.Element == URLQueryItem {
    subscript(_ key: String) -> String? {
        return first(where: { $0.name == key })?.value
    }
}

extension AppDelegate: GydeDelegate {

    func navigate(step: Steps, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: step.screenName)
                if type(of: topController) != type(of: vc) {
                    Gyde.sharedInstance.currentViewController = vc
                    topController.navigationController?.pushViewController(vc, animated: true)
                }
                completion()
            }
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
