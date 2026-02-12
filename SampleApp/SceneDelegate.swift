
//
//  SceneDelegate.swift
//  SampleApp
//
//  Created by Pranav Singh
//

import UIKit
import GesturePathKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // Use GesturePathTrackingWindow instead of plain UIWindow
        let config = GesturePathKitConfiguration(
            gradientStartColor: .systemPurple,
            gradientEndColor: .systemOrange,
            interactionCoordinateAlignment: .bottomLeft
        )
        let trackingWindow = GesturePathTrackingWindow(
            windowScene: windowScene,
            configuration: config
        )

        trackingWindow.rootViewController = UINavigationController(
            rootViewController: ViewController()
        )
        trackingWindow.makeKeyAndVisible()
        window = trackingWindow
    }
}
