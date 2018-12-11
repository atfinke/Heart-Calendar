//
//  AppDelegate.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let url = Bundle.main.url(forResource: "fabric.apikey", withExtension: nil),
            let key = try? String(contentsOf: url).replacingOccurrences(of: "\n", with: "") else {
                fatalError("Failed to get API keys")
        }
        Crashlytics.start(withAPIKey: key)

        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(red: 180.0/255.0,
                                                            green: 40.0/255.0,
                                                            blue: 60.0/255.0,
                                                            alpha: 1.0)

        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]

        return true
    }

}
