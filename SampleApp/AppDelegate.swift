
//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Pranav Singh
//

import UIKit
import GesturePathKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Create a regular UIWindow first, then wrap it with GesturePathTrackingWindow
        let plainWindow = UIWindow(frame: UIScreen.main.bounds)
        plainWindow.rootViewController = UINavigationController(
            rootViewController: ViewController()
        )

        let config = GesturePathKitConfiguration(
            gradientStartColor: .systemPurple,
            gradientEndColor: .systemOrange,
            interactionCoordinateAlignment: .bottomLeft
        )
        let trackingWindow = GesturePathTrackingWindow(
            window: plainWindow,
            configuration: config
        )
        trackingWindow.makeKeyAndVisible()
        window = trackingWindow
        return true
    }
}
