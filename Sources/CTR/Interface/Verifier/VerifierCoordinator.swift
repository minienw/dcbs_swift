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
	/// - Parameter result: the result of the start scene
	func didFinish(_ result: VerifierStartResult)

	/// The user finished the instruction scene
	/// - Parameter result: the result of the instruction scene
	func didFinish(_ result: ScanInstructionsResult)

	func navigateToScan()
    func navigateToAbout()

	/// Navigate to the scan result
	/// - Parameter attributes: the scanned attributes
	func navigateToScanResult(_ scanResult: (DCCQR?, String?))

	/// Display content
	/// - Parameters:
	///   - title: the title
	///   - content: the content
	func displayContent(title: String, content: [Content])
}

class VerifierCoordinator: SharedCoordinator {

	/// The factory for onboarding pages
	var onboardingFactory: OnboardingFactoryProtocol = VerifierOnboardingFactory()

	private var bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate() // swiftlint:disable:this weak_delegate

	// Designated starter method
	override func start() {
		
		if onboardingManager.needsOnboarding {
			/// Start with the onboarding
			let coordinator = OnboardingCoordinator(
				navigationController: navigationController,
				onboardingDelegate: self,
				factory: onboardingFactory,
				maxValidity: maxValidity
			)
			startChildCoordinator(coordinator)
			
		} else if onboardingManager.needsConsent {
			// Show the consent page
			let coordinator = OnboardingCoordinator(
				navigationController: navigationController,
				onboardingDelegate: self,
				factory: onboardingFactory,
				maxValidity: maxValidity
			)
			addChildCoordinator(coordinator)
			coordinator.navigateToConsent(shouldHideBackButton: true)

		} else {
			
			navigateToVerifierWelcome()
		}
	}
    
    override func openContentFrom() -> UINavigationController {
        return dashboardNavigationController ?? navigationController
    }
}

// MARK: - VerifierCoordinatorDelegate

extension VerifierCoordinator: VerifierCoordinatorDelegate {
	
	/// Navigate to verifier welcome scene
	func navigateToVerifierWelcome() {
		
		let dashboardViewController = VerifierStartViewController(
			viewModel: VerifierStartViewModel(
				coordinator: self,
				cryptoManager: cryptoManager,
				proofManager: proofManager
			)
		)
		dashboardNavigationController = VerifierStartNavigationController(rootViewController: dashboardViewController)

		window.rootViewController = dashboardNavigationController
	}

	func didFinish(_ result: VerifierStartResult) {

		switch result {
			case .userTappedProceedToScan:
				navigateToScan()

			case .userTappedProceedToScanInstructions:
				navigateToScanInstruction()
		}
	}

	/// The user finished the instruction scene
	/// - Parameter result: the result of the instruction scene
	func didFinish(_ result: ScanInstructionsResult) {

		navigateToScan()
	}
	
	/// Navigate to the scan result
	/// - Parameter attributes: the scanned attributes
	func navigateToScanResult(_ cryptoResults: (DCCQR?, String?)) {
		
		let viewController = VerifierResultViewController(
			viewModel: VerifierResultViewModel(
                coordinator: self,
                proofManager: proofManager,
				cryptoResults: cryptoResults,
				maxValidity: maxValidity
			)
		)
        dashboardNavigationController?.pushViewController(viewController, animated: false)
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

        dashboardNavigationController?.present(viewController, animated: true, completion: nil)
	}

	private func navigateToScanInstruction() {

		let destination = ScanInstructionsViewController(
			viewModel: ScanInstructionsViewModel(
				coordinator: self
			)
		)
        dashboardNavigationController?.pushViewController(destination, animated: true)
	}

	/// Navigate to the QR scanner
	func navigateToScan() {

		let destination = VerifierScanViewController(
			viewModel: VerifierScanViewModel(
				coordinator: self,
				cryptoManager: cryptoManager
			)
		)

        dashboardNavigationController?.pushViewController(destination, animated: true)
	}
    
    func navigateToAbout() {
        let versionSupplier = AppVersionSupplier()
        let destination = AboutViewController(viewModel:
                                                AboutViewModel(coordinator: self, versionSupplier: versionSupplier, flavor: .verifier)
        )
        dashboardNavigationController?.pushViewController(destination, animated: true)
    }
}
