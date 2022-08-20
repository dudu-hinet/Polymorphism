//
//  AppDelegate.swift
//  Polymorphism
//
//  Created by MGNE3TA/A on 2022/8/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let rootViewController = ViewController()
		self.window?.rootViewController = rootViewController
		self.window?.makeKeyAndVisible()
		
		return true
	}
}

