/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	/// The app coordinator for routing
	var appCoordinator: AppCoordinator?

	var previousBrightness: CGFloat?

    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.portrait

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		styleUI()
		previousBrightness = UIScreen.main.brightness
        
		if #available(iOS 13.0, *) {
			// Use Scene lifecycle
		} else {
			appCoordinator = AppCoordinator(navigationController: UINavigationController())
			appCoordinator?.start()
		}

		return true
	}

	// MARK: UISceneSession Lifecycle

	@available(iOS 13.0, *)
	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	@available(iOS 13.0, *)
	func application(
		_ application: UIApplication,
		didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running,
		// this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		if let brightness = previousBrightness {
			UIScreen.main.brightness = brightness
		}
	}

	func applicationWillResignActive(_ application: UIApplication) {
		if let brightness = previousBrightness {
			UIScreen.main.brightness = brightness
		}
	}

	func applicationWillTerminate(_ application: UIApplication) {
		if let brightness = previousBrightness {
			UIScreen.main.brightness = brightness
		}
	}

	// MARK: Orientation

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return self.orientationLock
	}

	// MARK: 3rd Party Keyboard

	func application(
		_ application: UIApplication,
		shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {

		// Reject 3rd Party Keyboards.
		return extensionPointIdentifier != .keyboard
	}

    // MARK: - Private

    /// Setup the appearance of the navigation bar
	private func styleUI() {
		
		// Custom navigation bar appearance
        let titleTextAttributed = [
            NSAttributedString.Key.foregroundColor: Theme.colors.dark,
            NSAttributedString.Key.font: Theme.fonts.bodyMontserrat
        ]
		UINavigationBar.appearance().titleTextAttributes = titleTextAttributed
		UINavigationBar.appearance().tintColor = Theme.colors.dark
		UINavigationBar.appearance().barTintColor = Theme.colors.viewControllerBackground
		
		// White navigation bar without bottom separator
		UINavigationBar.appearance().isTranslucent = false
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
		UINavigationBar.appearance().backgroundColor = Theme.colors.viewControllerBackground
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Theme.colors.viewControllerBackground
            appearance.titleTextAttributes = titleTextAttributed
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
	}
    
}
