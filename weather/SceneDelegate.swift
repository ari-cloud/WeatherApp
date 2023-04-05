//
//  SceneDelegate.swift
//  weather
//
//  Created by Арина Моргачева on 16.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = HistoryViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}

