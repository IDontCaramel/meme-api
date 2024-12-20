//
//  AppDelegate.swift
//  meme_api_frontend
//
//  Created by caramel on 11/12/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize the window with the screen bounds
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor(hex: "#202020FF")
        
        // Set the root view controller
        let mainViewController = ViewController() // Replace with your actual initial ViewController
        self.window?.rootViewController = mainViewController
        
        // Make the window key and visible
        self.window?.makeKeyAndVisible()
        
        // Perform startup tasks
        performStartupFunction()
        
        return true
    }
    
    func performStartupFunction() {
        // Add your startup logic here
    }
}
