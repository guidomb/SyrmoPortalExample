//
//  AppDelegate.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import UIKit
import PortalView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let skateTricks = feedItems(itemsCount: 20)
        let (root, component) = createFeedView(items: skateTricks)
        let presenter = UIKitComponentManager<Message>(window: window!)
        presenter.isDebugModeEnabled = false
        presenter.present(component: component, with: root, modally: false)
        
        
        //        fetchReplayImage(render: presenter.render)
        presenter.mailbox.subscribe { message in
            switch message {
                
            case .socialAction(let action):
                let alert: UIAlertController
                switch action {
                    
                case .like(let object):
                    alert = UIAlertController(
                        title: "Social action",
                        message: "Like / unlike object '\(object.value)'",
                        preferredStyle: .alert)
                    
                case .showComments(let object):
                    alert = UIAlertController(
                        title: "Social action",
                        message: "Show comments view for object '\(object.value)'",
                        preferredStyle: .alert)
                }
                
                alert.addAction(UIAlertAction(title: "OK", style: .`default`, handler: .none))
                self.window?.rootViewController?.present(alert, animated: true, completion: .none)
                
            case .show(let trickID):
                if let trick = skateTricks.first(where:  { $0.object.id.value == trickID.value }) {
                    let (root, component) = createDetailView(model: trick)
                    presenter.present(component: component, with: root, modally: false)
                }
                
            default:
                print("Message received: \(message)")
                
            }
        }
        
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

