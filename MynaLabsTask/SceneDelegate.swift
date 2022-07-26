//
//  SceneDelegate.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let homeNavigationController = UINavigationController(rootViewController: TabBarController())
        
        window?.rootViewController = homeNavigationController
        window?.makeKeyAndVisible()
    }
}
