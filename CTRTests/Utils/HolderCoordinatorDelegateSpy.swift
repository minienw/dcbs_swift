/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class HolderCoordinatorDelegateSpy: HolderCoordinatorDelegate {

	var navigateToAppointmentCalled = false
	var navigateToChooseProviderCalled = false
	var navigateToTokenOverviewCalled = false
	var navigateToTokenScanCalled = false
	var navigateToTokenEntryCalled = false
	var navigateToListResultsCalled = false
	var navigateToCreateProofCalled = false
	var navigateBackToStartCalled = false
	var presentInformationPageCalled = false

	func navigateToAppointment() {

		navigateToAppointmentCalled = true
	}

	func navigateToChooseProvider() {

		navigateToChooseProviderCalled = true
	}

	func navigateToTokenOverview() {

		navigateToTokenOverviewCalled = true
	}

	func navigateToTokenScan() {

		navigateToTokenScanCalled = true
	}

	func navigateToTokenEntry(_ token: RequestToken?) {

		navigateToTokenEntryCalled = true
	}

	func navigateToListResults() {

		navigateToListResultsCalled = true
	}

	func navigateToCreateProof() {

		navigateToCreateProofCalled = true
	}

	func navigateBackToStart() {

		navigateBackToStartCalled = true
	}

	func presentInformationPage(title: String, body: String, showBottomCloseButton: Bool) {

		presentInformationPageCalled = true
	}
}