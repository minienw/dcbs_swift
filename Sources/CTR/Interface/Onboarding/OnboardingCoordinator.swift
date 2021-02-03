/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {

	/// The user clicked on the next button
	/// - Parameter step: the current onboarding step
	func nextButtonClicked(step: OnboardingStep)
}

protocol OnboardingDelegate: AnyObject {

	/// The onboarding is finished
	func finishOnboarding()
}

class OnboardingCoordinator: Coordinator, Logging {

	var loggingCategory: String = "OnboardingCoordinator"

	/// The Child Coordinators
	var childCoordinators: [Coordinator] = []

	/// The navigation controller
	var navigationController: UINavigationController

	weak var onboardingDelegate: OnboardingDelegate?

	/// Initiatilzer
	init(
		navigationController: UINavigationController,
		onboardingDelegate: OnboardingDelegate) {

		self.navigationController = navigationController
		self.onboardingDelegate = onboardingDelegate
		onboardingPages = factory.create()
	}

	var onboardingPages: [OnboardingPage] = []

	var factory: OnboardingFactoryProtocol = OnboardingFactory()
	
	// Designated starter method
	func start() {

		if let info = onboardingPages.first {
			addOnboardingStep(info)
		}
	}

	/// Add an onboarding step
	/// - Parameter info: the info for the onboarding step
	func addOnboardingStep(_ info: OnboardingPage) {

		let viewController = OnboardingViewController(
			viewModel: OnboardingViewModel(
				coordinator: self,
				onboardingInfo: info,
				numberOfPages: onboardingPages.count
			)
		)
		navigationController.pushViewController(viewController, animated: true)
	}
}

// MARK: - OnboardingCoordinatorDelegate

extension OnboardingCoordinator: OnboardingCoordinatorDelegate {

	/// The user clicked on the next button
	/// - Parameter step: the current onboarding step
	func nextButtonClicked(step: OnboardingStep) {

		let rawValue = step.rawValue
		let nextValue = rawValue + 1

		if nextValue < onboardingPages.count {
			let info = onboardingPages[nextValue]
			addOnboardingStep(info)
		} else if nextValue == onboardingPages.count {

			self.logInfo("Onboarding completed!")
			onboardingDelegate?.finishOnboarding()
		}
	}
}