//
//  AppDelegate.swift
//  Heart Cal
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 270.0/255.0,
                                                            green: 70.0/255.0,
                                                            blue: 60.0/255.0,
                                                            alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        return true
    }

}

