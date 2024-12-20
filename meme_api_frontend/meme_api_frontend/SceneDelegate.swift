import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure that window is initialized with the correct window scene
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            // Set the root view controller
            window.rootViewController = ViewController() // Replace with your actual initial ViewController
            
            // Set the background color of the window (this sets the loading screen's background)
            window.backgroundColor = UIColor.systemBackground
            
            // Set the window as the key window
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Handle scene disconnect
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Handle scene becoming active
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Handle scene resigning active
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Handle scene entering foreground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Handle scene entering background
    }
}
