//
//  Untitled.swift
//  MovieQuiz
//
//  Created by mac on 28.10.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MovieQuizViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}

