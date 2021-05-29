/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR
import Nimble

class ShowQRViewModelTests: XCTestCase {

	/// Subject under test
	var sut: ShowQRViewModel!

	var holderCoordinatorDelegateSpy: HolderCoordinatorDelegateSpy!
	var cryptoManagerSpy: CryptoManagerSpy!
	var configSpy: ConfigurationGeneralSpy!
	var dataStoreManager: DataStoreManaging!

	override func setUp() {

		super.setUp()
		dataStoreManager = DataStoreManager(.inMemory)
		holderCoordinatorDelegateSpy = HolderCoordinatorDelegateSpy()
		cryptoManagerSpy = CryptoManagerSpy()
		configSpy = ConfigurationGeneralSpy()
	}

	// MARK: - Tests

	/// Test all the default content
	func test_content_withDomesticGreenCard() throws {

		// Given
		let greenCard = try XCTUnwrap(
			GreenCardModel.createTestGreenCard(
				dataStoreManager: dataStoreManager,
				type: .domestic,
				withValidCredential: true
			)
		)

		// When
		sut = ShowQRViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			greenCard: greenCard,
			cryptoManager: cryptoManagerSpy,
			configuration: configSpy
		)

		// Then
		expect(self.sut.showValidQR) == false
		expect(self.sut.hideForCapture) == false
		expect(self.sut.title) == .holderShowQRDomesticTitle
	}

	/// Test all the default content
	func test_content_withEuGreenCard() throws {

		// Given
		let greenCard = try XCTUnwrap(
			GreenCardModel.createTestGreenCard(
				dataStoreManager: dataStoreManager,
				type: .eu,
				withValidCredential: true
			)
		)

		// When
		sut = ShowQRViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			greenCard: greenCard,
			cryptoManager: cryptoManagerSpy,
			configuration: configSpy
		)

		// Then
		expect(self.sut.showValidQR) == false
		expect(self.sut.hideForCapture) == false
		expect(self.sut.title) == .holderShowQREuTitle
	}

	func test_validity_withDomesticGreenCard_withoutCredential() throws {

		// Given
		let greenCard = try XCTUnwrap(
			GreenCardModel.createTestGreenCard(
				dataStoreManager: dataStoreManager,
				type: .domestic,
				withValidCredential: false
			)
		)
		sut = ShowQRViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			greenCard: greenCard,
			cryptoManager: cryptoManagerSpy,
			configuration: configSpy
		)

		// When
		sut?.checkQRValidity()

		// Then
		expect(self.holderCoordinatorDelegateSpy.invokedNavigateBackToStart) == true
	}

	func test_validity_withEuGreenCard_withoutCredential() throws {

		// Given
		let greenCard = try XCTUnwrap(
			GreenCardModel.createTestGreenCard(
				dataStoreManager: dataStoreManager,
				type: .eu,
				withValidCredential: false
			)
		)
		sut = ShowQRViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			greenCard: greenCard,
			cryptoManager: cryptoManagerSpy,
			configuration: configSpy
		)

		// When
		sut?.checkQRValidity()

		// Then
		expect(self.holderCoordinatorDelegateSpy.invokedNavigateBackToStart) == true
	}

	func test_validity_withDomesticGreenCard_withValidCredential() throws {

		// Given
		let greenCard = try XCTUnwrap(
			GreenCardModel.createTestGreenCard(
				dataStoreManager: dataStoreManager,
				type: .domestic,
				withValidCredential: true
			)
		)
		sut = ShowQRViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			greenCard: greenCard,
			cryptoManager: cryptoManagerSpy,
			configuration: configSpy
		)
		cryptoManagerSpy.stubbedGenerateQRmessageResult = Data()

		// When
		sut?.checkQRValidity()

		// Then
		expect(self.cryptoManagerSpy.invokedGenerateQRmessage) == true
		expect(self.sut.showValidQR) == true
		expect(self.sut.qrMessage).toNot(beNil())
		expect(self.sut.validityTimer).toNot(beNil())
		expect(self.holderCoordinatorDelegateSpy.invokedNavigateBackToStart) == false
	}

	func test_validity_withEuGreenCard_withValidCredential() throws {

		// Given
		let greenCard = try XCTUnwrap(
			GreenCardModel.createTestGreenCard(
				dataStoreManager: dataStoreManager,
				type: .eu,
				withValidCredential: true
			)
		)
		sut = ShowQRViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			greenCard: greenCard,
			cryptoManager: cryptoManagerSpy,
			configuration: configSpy
		)

		// When
		sut?.checkQRValidity()

		// Then
		expect(self.cryptoManagerSpy.invokedGenerateQRmessage) == false
		expect(self.sut.showValidQR) == true
		expect(self.sut.qrMessage).toNot(beNil())
		expect(self.sut.validityTimer).toNot(beNil())
		expect(self.holderCoordinatorDelegateSpy.invokedNavigateBackToStart) == false
	}

	/// Test taking a screenshot
	func testScreenshot() throws {

		// Given
		let greenCard = try XCTUnwrap(
			GreenCardModel.createTestGreenCard(
				dataStoreManager: dataStoreManager,
				type: .domestic,
				withValidCredential: false
			)
		)
		sut = ShowQRViewModel(
			coordinator: holderCoordinatorDelegateSpy,
			greenCard: greenCard,
			cryptoManager: cryptoManagerSpy,
			configuration: configSpy
		)

		// When
		NotificationCenter.default.post(
			name: UIApplication.userDidTakeScreenshotNotification,
			object: nil,
			userInfo: nil
		)

		// Then
		expect(self.sut.showScreenshotWarning) == true
	}
}

extension GreenCardModel {

	static func createTestGreenCard(dataStoreManager: DataStoreManaging, type: GreenCardType, withValidCredential: Bool) -> GreenCard? {

		var result: GreenCard?
		let context = dataStoreManager.managedObjectContext()
		context.performAndWait {

			if let wallet = WalletModel.createTestWallet(managedContext: context) {
				result = GreenCardModel.create(
					type: type,
					wallet: wallet,
					managedContext: context
				)
				if withValidCredential, let greenCard = result {
					let now = Date().timeIntervalSince1970 - 200
					let expiration = now + 3600
					CredentialModel.create(
						data: Data(),
						validFrom: Date(timeIntervalSince1970: now),
						expirationTime: Date(timeIntervalSince1970: expiration),
						greenCard: greenCard,
						managedContext: context
					)
				}
			}
		}
		return result
	}
}
