/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR
import Nimble

class VerifierResultViewModelTests: XCTestCase {
	
	/// Subject under test
	var sut: VerifierResultViewModel!
	
	/// The coordinator spy
	var verifyCoordinatorDelegateSpy: VerifierCoordinatorDelegateSpy!
	
	/// Date parser
	private lazy var parseDateFormatter: ISO8601DateFormatter = {
		let dateFormatter = ISO8601DateFormatter()
		return dateFormatter
	}()
	
	override func setUp() {
		
		super.setUp()
		verifyCoordinatorDelegateSpy = VerifierCoordinatorDelegateSpy()
		
		sut = VerifierResultViewModel(
			coordinator: verifyCoordinatorDelegateSpy,
			cryptoResults: CryptoResult(
				attributes: CryptoAttributes(
					birthDay: nil,
					birthMonth: nil,
					credentialVersion: nil,
					domesticDcc: "0",
					firstNameInitial: nil,
					lastNameInitial: nil,
					specimen: "0"
				),
				errorMessage: nil
			),
			maxValidity: 48
		)
	}
	
	// MARK: - Tests
	
	func test_checkAttributes_shouldDisplayDemo() {
		
		// Given
		sut.cryptoResults = CryptoResult(
			attributes:
				CryptoAttributes(
					birthDay: nil,
					birthMonth: nil,
					credentialVersion: nil,
					domesticDcc: "0",
					firstNameInitial: nil,
					lastNameInitial: nil,
					specimen: "1"
				),
			errorMessage: nil
		)
		
		// When
		sut.checkAttributes()
		
		// Then
		expect(self.sut.allowAccess) == .demo
		expect(self.sut.title) == .verifierResultDemoTitle
		expect(self.sut.message).to(beNil(), description: "Message should be nil")
	}
	
	func test_checkAttributes_whenNoAttributesAreSet_shouldDisplayDeniedInvalidQR() {
		
		// Given
		sut.cryptoResults = CryptoResult(
			attributes: nil,
			errorMessage: nil
		)
		
		// When
		sut.checkAttributes()
		
		// Then
		expect(self.sut.allowAccess) == .denied
		expect(self.sut.title) == .verifierResultDeniedTitle
		expect(self.sut.message) == .verifierResultDeniedMessage
	}
	
	func test_checkAttributes_shouldDisplayDeniedDomesticDcc() {
		
		// Given
		sut.cryptoResults = CryptoResult(
			attributes: CryptoAttributes(
				birthDay: nil,
				birthMonth: nil,
				credentialVersion: nil,
				domesticDcc: "1",
				firstNameInitial: nil,
				lastNameInitial: nil,
				specimen: "0"
			),
			errorMessage: nil
		)
		
		// When
		sut.checkAttributes()
		
		// Then
		expect(self.sut.allowAccess) == .denied
		expect(self.sut.title) == .verifierResultDeniedRegionTitle
		expect(self.sut.message) == .verifierResultDeniedRegionMessage
	}
	
	func test_checkAttributes_whenSpecimenIsSet_shouldDisplayDeniedDomesticDcc() {
		
		// Given
		sut.cryptoResults = CryptoResult(
			attributes: CryptoAttributes(
				birthDay: nil,
				birthMonth: nil,
				credentialVersion: nil,
				domesticDcc: "1",
				firstNameInitial: nil,
				lastNameInitial: nil,
				specimen: "1"
			),
			errorMessage: nil
		)
		
		// When
		sut.checkAttributes()
		
		// Then
		expect(self.sut.allowAccess) == .denied
		expect(self.sut.title) == .verifierResultDeniedRegionTitle
		expect(self.sut.message) == .verifierResultDeniedRegionMessage
	}
	
	func test_checkAttributes_shouldDisplayVerified() {
		
		// Given
		sut.cryptoResults = CryptoResult(
			attributes:
				CryptoAttributes(
					birthDay: nil,
					birthMonth: nil,
					credentialVersion: nil,
					domesticDcc: "0",
					firstNameInitial: nil,
					lastNameInitial: nil,
					specimen: "0"
				),
			errorMessage: nil
		)
		
		// When
		sut.checkAttributes()
		
		// Then
		expect(self.sut.allowAccess) == .verified
		expect(self.sut.title) == .verifierResultAccessTitle
		expect(self.sut.message).to(beNil(), description: "Message should be nil")
	}

	func testDismiss() {
		
		// Given
		
		// When
		sut.dismiss()
		
		// Then
		expect(self.verifyCoordinatorDelegateSpy.invokedNavigateToVerifierWelcome) == true
	}
	
	func testScanAgain() {
		
		// Given
		
		// When
		sut.scanAgain()
		
		// Then
		expect(self.verifyCoordinatorDelegateSpy.invokedNavigateToScan) == true
	}
	
	func testLinkTappedDenied() {
		
		// Given
		sut.allowAccess = .denied
		
		// When
		sut.linkTapped()
		
		// Then
		expect(self.verifyCoordinatorDelegateSpy.invokedDisplayContent) == true
	}
	
	func testLinkTappedAllowed() {
		
		// Given
		sut.allowAccess = .verified
		
		// When
		sut.linkTapped()
		
		// Then
		expect(self.verifyCoordinatorDelegateSpy.invokedDisplayContent) == true
	}
}
