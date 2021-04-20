/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR
import Nimble

class VerifierStartViewModelTests: XCTestCase {

	/// Subject under test
	var sut: VerifierStartViewModel!

	var cryptoManagerSpy: CryptoManagerSpy!
	var proofManagerSpy: ProofManagingSpy!
	var verifyCoordinatorDelegateSpy: VerifierCoordinatorDelegateSpy!
	var userSettingsSpy: UserSettingsSpy!

	override func setUp() {

		super.setUp()
		verifyCoordinatorDelegateSpy = VerifierCoordinatorDelegateSpy()
		cryptoManagerSpy = CryptoManagerSpy()
		proofManagerSpy = ProofManagingSpy()
		userSettingsSpy = UserSettingsSpy()

		sut = VerifierStartViewModel(
			coordinator: verifyCoordinatorDelegateSpy,
			cryptoManager: cryptoManagerSpy,
			proofManager: proofManagerSpy,
			userSettings: userSettingsSpy
		)
	}

	// MARK: - Tests

	func test_defaultContent() {

		// Given

		// When

		// Then
		expect(self.sut.primaryButtonTitle)
			.to(equal(.verifierStartButtonTitle), description: "Button title should match")
		expect(self.sut.title)
			.to(equal(.verifierStartTitle), description: "Title should match")
		expect(self.sut.header)
			.to(equal(.verifierStartHeader), description: "Header should match")
		expect(self.sut.message)
			.to(equal(.verifierStartMessage), description: "Message should match")
	}

	func test_linkTapped() {

		// Given

		// When
		sut.linkTapped()

		// Then
		expect(self.verifyCoordinatorDelegateSpy.navigateToScanInstructionCalled) == true
	}

	func test_primaryButtonTapped_noScanInstructionsShown() {

		// Given
		userSettingsSpy.stubbedScanInstructionShown = false

		// When
		sut.primaryButtonTapped()

		// Then
		expect(self.verifyCoordinatorDelegateSpy.navigateToScanInstructionCalled) == true
		expect(self.userSettingsSpy.invokedScanInstructionShownGetter) == true
	}

	func test_primaryButtonTapped_scanInstructionsShown_havePublicKeys() {

		// Given
		userSettingsSpy.stubbedScanInstructionShown = true
		cryptoManagerSpy.keys = [IssuerPublicKey(identifier: "test", publicKey: "test")]

		// When
		sut.primaryButtonTapped()

		// Then
		expect(self.verifyCoordinatorDelegateSpy.navigateToScanCalled) == true
	}

	func test_primaryButtonTapped_scanInstructionsShown_noPublicKeys() {

		// Given
		userSettingsSpy.stubbedScanInstructionShown = true
		cryptoManagerSpy.keys = []

		// When
		sut.primaryButtonTapped()

		// Then
		expect(self.proofManagerSpy.invokedFetchIssuerPublicKeys) == true
		expect(self.sut.showError) == true
	}
}