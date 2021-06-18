/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

protocol VerifierCoordinatorDelegate: AnyObject {
	
	/// Navigate to verifier welcome scene
	func navigateToVerifierWelcome()

	/// The user finished the start scene
	func didFinish()

	func navigateToScan()

	/// Navigate to the scan result
	/// - Parameter attributes: the scanned attributes
	func navigateToScanResult(_ scanResult: CryptoResult)

	/// Display content
	/// - Parameters:
	///   - title: the title
	///   - content: the content
	func displayContent(title: String, content: [Content])
}

class VerifierCoordinator: SharedCoordinator {

	private var bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate() // swiftlint:disable:this weak_delegate

	// Designated starter method
	override func start() {
					
		navigateToVerifierWelcome()
	}
}

// MARK: - VerifierCoordinatorDelegate

extension VerifierCoordinator: VerifierCoordinatorDelegate {
	
	/// Navigate to verifier welcome scene
	func navigateToVerifierWelcome() {
		
		let menu = MenuViewController(
            viewModel: MenuViewModel(delegate: self)
		)
		sidePanel = SidePanelController(sideController: UINavigationController(rootViewController: menu))
		
		let dashboardViewController = VerifierStartViewController(
			viewModel: VerifierStartViewModel(
				coordinator: self,
				cryptoManager: cryptoManager,
				proofManager: proofManager
			)
		)
		dashboardNavigationController = UINavigationController(rootViewController: dashboardViewController)
		sidePanel?.selectedViewController = dashboardNavigationController
		
		// Replace the root with the side panel controller
		window.rootViewController = sidePanel
	}

	func didFinish() {

		navigateToScan()
	}
	
	/// Navigate to the scan result
	/// - Parameter attributes: the scanned attributes
	func navigateToScanResult(_ cryptoResults: CryptoResult) {
		
		let viewController = VerifierResultViewController(
			viewModel: VerifierResultViewModel(
				coordinator: self,
				cryptoResults: cryptoResults,
				maxValidity: maxValidity
			)
		)
		(sidePanel?.selectedViewController as? UINavigationController)?.pushViewController(viewController, animated: false)
	}

	/// Display content
	/// - Parameters:
	///   - title: the title
	///   - content: the content
	func displayContent(title: String, content: [Content]) {

		let viewController = DisplayContentViewController(
			viewModel: DisplayContentViewModel(
				coordinator: self,
				title: title,
				content: content
			)
		)

		viewController.transitioningDelegate = bottomSheetTransitioningDelegate
		viewController.modalPresentationStyle = .custom
		viewController.modalTransitionStyle = .coverVertical

		sidePanel?.selectedViewController?.present(viewController, animated: true, completion: nil)
	}

	/// Navigate to the QR scanner
	func navigateToScan() {

//		navigateToScanResult(
//			(attributes: CryptoAttributes(
//				birthDay: "27",
//				birthMonth: "5",
//				credentialVersion: "1",
//				domesticDcc: "0",
//				firstNameInitial: "G",
//				lastNameInitial: "C",
//				specimen: "0"),
//			 errorMessage: nil
//			)
//		)

		let destination = VerifierScanViewController(
			viewModel: VerifierScanViewModel(
				coordinator: self,
				cryptoManager: cryptoManager
			)
		)

		(sidePanel?.selectedViewController as? UINavigationController)?.setViewControllers([destination], animated: true)
	}
}
// MARK: - MenuDelegate

extension VerifierCoordinator: MenuDelegate {
	
	/// Close the menu
	func closeMenu() {
		
		sidePanel?.hideSidePanel()
	}
	
	/// Open a menu item
	/// - Parameter identifier: the menu identifier
	func openMenuItem(_ identifier: MenuIdentifier) {
		
		switch identifier {
			case .overview:
				dashboardNavigationController?.popToRootViewController(animated: false)
				sidePanel?.selectedViewController = dashboardNavigationController
				
			default:
				self.logInfo("User tapped on \(identifier), not implemented")
				
				let destinationViewController = PlaceholderViewController()
				destinationViewController.placeholder = "\(identifier)"
				let navigationController = UINavigationController(rootViewController: destinationViewController)
				sidePanel?.selectedViewController = navigationController
		}
		fixRotation()
	}

	func fixRotation() {
		
		if let frame = sidePanel?.view.frame {
			sidePanel?.selectedViewController?.view.frame = frame
		}
	}
	
	/// Get the items for the top menu
	/// - Returns: the top menu items
	func getTopMenuItems() -> [MenuItem] {
		
		return [
			MenuItem(identifier: .overview, title: .verifierMenuDashboard)
		]
	}
	/// Get the items for the bottom menu
	/// - Returns: the bottom menu items
	func getBottomMenuItems() -> [MenuItem] {
		
		return []
	}
}
