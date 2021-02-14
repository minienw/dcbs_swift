/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

protocol Dismissable: AnyObject {

	/// Dismiss the presented viewcontroller
	func dismiss()
}

// swiftlint:disable class_delegate_protocol
protocol HolderCoordinatorDelegate: Dismissable {

	// MARK: Navigation

	/// Navigate to appointment
	func navigateToAppointment()

	/// Navigate to choose provider
	func navigateToChooseProvider()

	/// Navigate to the token overview scene
	func navigateToTokenOverview()

	/// Navigate to the token scanner
	func navigateToTokenScan()

	/// Navigate to the token entry scene
	func navigateToTokenEntry(_ token: RequestToken?)

	/// Navigate to List Results Scene
	func navigateToListResults()

	/// Navigate to create proof
	func navigateToCreateProof()

	/// Navigate to the start fo the holder flow
	func navigateBackToStart()

	/// Show an information page
	/// - Parameters:
	///   - title: the title of the page
	///   - body: the body of the page
	func presentInformationPage(title: String, body: String)

	/// Open a url
	func openUrl(_ url: URL)

	// MARK: Menu

	/// Close the menu
	func closeMenu()

	/// Open a menu item
	/// - Parameter identifier: the menu identifier
	func openMenuItem(_ identifier: MenuIdentifier)
}
// swiftlint:enable class_delegate_protocol

class HolderCoordinator: Coordinator, Logging {

	var loggingCategory: String = "HolderCoordinator"

	/// The UI Window
	private var window: UIWindow

	var coronaTestProof: CTRModel?

	/// The side panel controller
	var sidePanel: SidePanelController?

	/// The onboardings manager
	var onboardingManager: OnboardingManaging = Services.onboardingManager

	/// The proof manager
	var proofManager: ProofManaging = Services.proofManager

	/// The crypto manager
	var cryptoManager: CryptoManaging = Services.cryptoManager

	/// The network manager
	var networkManager: NetworkManaging = Services.networkManager

	/// The open ID manager
	var openIdManager: OpenIdManaging = Services.openIdManager

	/// The general configuration
	var generalConfiguration: ConfigurationGeneralProtocol = Configuration()

	/// The Child Coordinators
	var childCoordinators: [Coordinator] = []

	/// The navigation controller
	var navigationController: UINavigationController

	var dashboardNavigationContoller: UINavigationController?

	/// Initiatilzer
	init(navigationController: UINavigationController, window: UIWindow) {

		self.navigationController = navigationController
		self.window = window
	}

	// Designated starter method
	func start() {

		// Fetch the details for the proof manager
		proofManager.fetchCoronaTestProviders()
		//		proofManager.fetchTestTypes()

		if onboardingManager.needsOnboarding {
			/// Start with the onboarding
			let coordinator = OnboardingCoordinator(
				navigationController: navigationController,
				onboardingDelegate: self
			)
			startChildCoordinator(coordinator)

		} else if onboardingManager.needsConsent {
			// Show the consent page
			let coordinator = OnboardingCoordinator(
				navigationController: navigationController,
				onboardingDelegate: self
			)
			addChildCoordinator(coordinator)
			coordinator.navigateToConsent()
		} else {

			// Start with the holder app
			navigateToHolderStart()
		}
	}
}

// MARK: - HolderCoordinatorDelegate

extension HolderCoordinator: HolderCoordinatorDelegate {

	// MARK: Navigation

	func navigateToHolderStart() {

		let menu = HolderMenuViewController(
			viewModel: HolderMenuViewModel(
				coordinator: self
			)
		)
		sidePanel = CustomSidePanelController(sideController: UINavigationController(rootViewController: menu))
		let dashboardViewController = HolderDashboardViewController(
			viewModel: HolderDashboardViewModel(
				coordinator: self,
				cryptoManager: cryptoManager,
				proofManager: proofManager,
				configuration: generalConfiguration
			)
		)
		dashboardNavigationContoller = UINavigationController(rootViewController: dashboardViewController)
		sidePanel?.selectedViewController = dashboardNavigationContoller

		// Replace the root with the side panel controller
		window.rootViewController = sidePanel
	}

	/// Navigate to appointment
	func navigateToAppointment() {

		let destination = AppointmentViewController(
			viewModel: AppointmentViewModel(
				coordinator: self
			)
		)
		(sidePanel?.selectedViewController as? UINavigationController)?.pushViewController(destination, animated: true)
	}

	/// Navigate to choose provider
	func navigateToChooseProvider() {

		let destination = ChooseProviderViewController(
			viewModel: ChooseProviderViewModel(
				coordinator: self,
				openIdManager: openIdManager
			)
		)
		(sidePanel?.selectedViewController as? UINavigationController)?.pushViewController(destination, animated: true)

	}
	/// Navigate to the token overview scene
	func navigateToTokenOverview() {

		let destination = TokenOverviewViewController(
			viewModel: TokenOverviewViewModel(
				coordinator: self
			)
		)
		(sidePanel?.selectedViewController as? UINavigationController)?.pushViewController(destination, animated: true)
	}

	/// Navigate to the token scanner
	func navigateToTokenScan() {

		let destination = TokenScanViewController(
			viewModel: TokenScanViewModel(
				coordinator: self
			)
		)

		(sidePanel?.selectedViewController as? UINavigationController)?.pushViewController(destination, animated: true)
	}

	/// Navigate to the token entry scene
	func navigateToTokenEntry(_ token: RequestToken? = nil) {

		let destination = TokenEntryViewController(
			viewModel: TokenEntryViewModel(
				coordinator: self,
				proofManager: proofManager,
				requestToken: token
			)
		)
		(sidePanel?.selectedViewController as? UINavigationController)?.pushViewController(destination, animated: true)
	}

	/// Navigate to List Results Scene
	func navigateToListResults() {

		let viewController = ListResultsViewController(
			viewModel: ListResultsViewModel(
				coordinator: self,
				proofManager: proofManager
			)
		)
		let destination = UINavigationController(rootViewController: viewController)
		navigationController = destination

		sidePanel?.selectedViewController?.present(destination, animated: true, completion: nil)
	}

	/// Navigate to create proof
	func navigateToCreateProof() {
		let viewController = CreateProofViewController(
			viewModel: CreateProofViewiewModel(
				coordinator: self,
				proofManager: proofManager,
				cryptoManager: cryptoManager,
				networkManager: networkManager
			)
		)

		navigationController.pushViewController(viewController, animated: true)
	}

	/// Navigate to the start fo the holder flow
	func navigateBackToStart() {

		sidePanel?.selectedViewController?.dismiss(animated: true, completion: nil)
		(sidePanel?.selectedViewController as? UINavigationController)?.popToRootViewController(animated: true)
	}

	func dismiss() {
		sidePanel?.selectedViewController?.dismiss(animated: true, completion: nil)
	}

	/// Show an information page
	/// - Parameters:
	///   - title: the title of the page
	///   - body: the body of the page
	func presentInformationPage(title: String, body: String) {

		let viewController = InformationViewController(
			viewModel: InformationViewModel(
				coordinator: self,
				title: title,
				message: body
			)
		)
		let destination = UINavigationController(rootViewController: viewController)
		sidePanel?.selectedViewController?.present(destination, animated: true, completion: nil)
	}

	/// Open a url
	func openUrl(_ url: URL) {

		UIApplication.shared.open(url)
	}

	// MARK: Menu

	/// Close the menu
	func closeMenu() {

		sidePanel?.hideSidePanel()
	}

	/// Open a menu item
	/// - Parameter identifier: the menu identifier
	func openMenuItem(_ identifier: MenuIdentifier) {

		switch identifier {
			case .overview:
				dashboardNavigationContoller?.popToRootViewController(animated: false)
				sidePanel?.selectedViewController = dashboardNavigationContoller
			default:
				self.logInfo("User tapped on \(identifier), not implemented")

				let destinationViewController = PlaceholderViewController()
				destinationViewController.placeholder = "\(identifier)"
				let navigationController = UINavigationController(rootViewController: destinationViewController)
				sidePanel?.selectedViewController = navigationController
		}
	}
}

extension HolderCoordinator: OnboardingDelegate {

	/// User has seen all the onboarding pages
	func finishOnboarding() {

		onboardingManager.finishOnboarding()
	}

	/// The onboarding is finished
	func consentGiven() {

		// Mark as complete
		onboardingManager.consentGiven()

		// Remove child coordinator
		if let onboardingCoorinator = childCoordinators.first {
			removeChildCoordinator(onboardingCoorinator)
		}

		// Navigate to Holder Start.
		navigateToHolderStart()
	}
}
