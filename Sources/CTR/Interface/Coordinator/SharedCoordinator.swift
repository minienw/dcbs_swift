/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit
import SafariServices

protocol Dismissable: AnyObject {

	/// Dismiss the presented viewcontroller
	func dismiss()
}

protocol OpenUrlProtocol: AnyObject {

	/// Open a url
	/// - Parameters:
	///   - url: The url to open
	///   - inApp: True if we should open the url in a in-app browser, False if we want the OS to handle the url
	func openUrl(_ url: URL, inApp: Bool)
}

/// The shared base class for the holder and verifier coordinator.
class SharedCoordinator: Coordinator, Logging {

	var loggingCategory: String = "SharedCoordinator"

	var window: UIWindow

	/// The side panel controller that holds both the menu and the main view
	var sidePanel: SidePanelController?

	var cryptoManager: CryptoManaging = Services.cryptoManager
	var generalConfiguration: ConfigurationGeneralProtocol = Configuration()
	var remoteConfigManager: RemoteConfigManaging = Services.remoteConfigManager
	var proofManager: ProofManaging = Services.proofManager
	var versionSupplier = AppVersionSupplier()
	var childCoordinators: [Coordinator] = []

	// Navigation controllers for each of the flows from the menu
	var navigationController: UINavigationController
	var dashboardNavigationController: UINavigationController?
	var aboutNavigationController: UINavigationController?

	var maxValidity: Int {
		remoteConfigManager.getConfiguration().maxValidityHours ?? 40
	}

	/// Initiatilzer
	init(navigationController: UINavigationController, window: UIWindow) {

		self.navigationController = navigationController
		self.window = window
	}

	// Designated starter method
	func start() {

		// To be overwritten
	}

    // MARK: - Universal Link handling

    /// Override point for coordinators which wish to deal with universal links.
    func consume(universalLink: UniversalLink) -> Bool {
        return false
    }
}

// MARK: - Dismissable

extension SharedCoordinator: Dismissable {

	func dismiss() {

		if sidePanel?.selectedViewController?.presentedViewController != nil {
			sidePanel?.selectedViewController?.dismiss(animated: true, completion: nil)
		} else {
			(sidePanel?.selectedViewController as? UINavigationController)?.popViewController(animated: false)
		}
	}
}

// MARK: - OpenUrlProtocol

extension SharedCoordinator: OpenUrlProtocol {

	/// Open a url
	/// - Parameters:
	///   - url: The url to open
	///   - inApp: True if we should open the url in a in-app browser, False if we want the OS to handle the url
	func openUrl(_ url: URL, inApp: Bool) {

		var shouldOpenInApp = inApp
		if url.scheme == "tel" {
			// Do not open phone numbers in app, doesn't work & will crash.
			shouldOpenInApp = false
		}

		if shouldOpenInApp {
			let safariController = SFSafariViewController(url: url)

			if let presentedViewController = sidePanel?.selectedViewController?.presentedViewController {
				presentedViewController.presentingViewController?.dismiss(animated: true, completion: {
					self.sidePanel?.selectedViewController?.present(safariController, animated: true)
				})
			} else {
				sidePanel?.selectedViewController?.present(safariController, animated: true)
			}
		} else {
			UIApplication.shared.open(url)
		}
	}
}
