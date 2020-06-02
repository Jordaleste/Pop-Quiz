//
//  AppDelegate.swift
//  Pop Quiz
//
//  Created by Charles Eison on 5/13/20.
//  Copyright © 2020 Charles Eison. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Reset User Default Values
//        UserDefaults.standard.set(0, forKey: "highScore")
//        CategoryManager.categories.map {$0.key}.forEach { (category) in
//            UserDefaults.standard.set(0, forKey: "\(category)HighScore")
//        }
        
        
        // Override point for customization after application launch.
        
        //Keep track of number of times App has been opened
        var numberTimesOpened = UserDefaults.standard.integer(forKey: "appOpens")
        numberTimesOpened += 1
        UserDefaults.standard.set(numberTimesOpened, forKey: "appOpens")
        
        if numberTimesOpened > 5 {
            SKStoreReviewController.requestReview()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

