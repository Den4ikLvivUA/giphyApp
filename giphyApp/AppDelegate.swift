//
//  AppDelegate.swift
//  giphyApp
//
//  Created by MacBook on 5/21/20.
//  Copyright © 2020 den4iklvivua. All rights reserved.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SearchViewController()
        window?.makeKeyAndVisible()
        
        return true
    }


}

