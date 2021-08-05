/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR
import Nimble

class LaunchViewModelTests: XCTestCase {

	private var sut: LaunchViewModel!
	private var appCoordinatorSpy: AppCoordinatorSpy!
	private var versionSupplierSpy: AppVersionSupplierSpy!
	private var remoteConfigSpy: RemoteConfigManagingSpy!
	private var proofManagerSpy: ProofManagingSpy!
	private var cryptoLibUtilitySpy: CryptoLibUtilitySpy!

	override func setUp() {
		super.setUp()

		appCoordinatorSpy = AppCoordinatorSpy()
		versionSupplierSpy = AppVersionSupplierSpy(version: "1.0.0")
		remoteConfigSpy = RemoteConfigManagingSpy()
		proofManagerSpy = ProofManagingSpy()
		cryptoLibUtilitySpy = CryptoLibUtilitySpy()
		remoteConfigSpy.stubbedGetConfigurationResult = remoteConfig
	}

	let remoteConfig = RemoteConfiguration(
		minVersion: "1.0",
		minVersionMessage: "test message",
		storeUrl: URL(string: "https://apple.com"),
		deactivated: nil,
		informationURL: nil,
		configTTL: 3600,
		euLaunchDate: "2021-06-03T14:00:00+00:00",
		maxValidityHours: 48,
		requireUpdateBefore: nil,
		temporarilyDisabled: false,
		vaccinationValidityHours: 14600,
		recoveryValidityHours: 7300,
		testValidityHours: 40,
		domesticValidityHours: 40,
		vaccinationEventValidity: 14600,
		recoveryEventValidity: 7300,
		testEventValidity: 40,
		isGGDEnabled: true
	)

	// MARK: Tests

	func test_initializeVerifier() {

		// Given

		// When
		sut = LaunchViewModel(
			coordinator: appCoordinatorSpy,
			versionSupplier: versionSupplierSpy,
			remoteConfigManager: remoteConfigSpy,
			proofManager: proofManagerSpy
		)

		// Then
		expect(self.sut.title) == .verifierLaunchTitle
		expect(self.sut.message) == .verifierLaunchText
		expect(self.sut.appIcon) == .verifierAppIcon
	}

	func test_noActionRequired() {

		// Given
		remoteConfigSpy.stubbedUpdateCompletionResult = (.noActionNeeded, ())
		proofManagerSpy.shouldInvokeFetchIssuerPublicKeysOnCompletion = true
		cryptoLibUtilitySpy.stubbedIsInitialized = true

		// When
		sut = LaunchViewModel(
			coordinator: appCoordinatorSpy,
			versionSupplier: versionSupplierSpy,
			remoteConfigManager: remoteConfigSpy,
			proofManager: proofManagerSpy,
			cryptoLibUtility: cryptoLibUtilitySpy
		)

		// Then
		expect(self.remoteConfigSpy.invokedUpdate) == true
		expect(self.proofManagerSpy.invokedFetchIssuerPublicKeys) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchState) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchStateParameters?.state) == LaunchState.noActionNeeded
		expect(self.cryptoLibUtilitySpy.invokedIsInitializedGetter) == true
	}

	/// Test internet required for the remote config
	func test_internetRequiredRemoteConfig() {

		// Given
		remoteConfigSpy.stubbedUpdateCompletionResult = (.internetRequired, ())
		proofManagerSpy.shouldInvokeFetchIssuerPublicKeysOnCompletion = true
		cryptoLibUtilitySpy.stubbedIsInitialized = true

		// When
		sut = LaunchViewModel(
			coordinator: appCoordinatorSpy,
			versionSupplier: versionSupplierSpy,
			remoteConfigManager: remoteConfigSpy,
			proofManager: proofManagerSpy,
			cryptoLibUtility: cryptoLibUtilitySpy
		)

		// Then
		expect(self.remoteConfigSpy.invokedUpdate) == true
		expect(self.proofManagerSpy.invokedFetchIssuerPublicKeys) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchState) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchStateParameters?.state) == LaunchState.internetRequired
		expect(self.cryptoLibUtilitySpy.invokedIsInitializedGetter) == false
	}

	/// Test internet required for the issuer public keys
	func testInternetRequiredIssuerPublicKeys() {

		// Given
		remoteConfigSpy.stubbedUpdateCompletionResult = (.noActionNeeded, ())
		let error = NSError(
			domain: NSURLErrorDomain,
			code: URLError.notConnectedToInternet.rawValue
		)
		proofManagerSpy.stubbedFetchIssuerPublicKeysOnErrorResult = (error, ())
		cryptoLibUtilitySpy.stubbedIsInitialized = true

		// When
		sut = LaunchViewModel(
			coordinator: appCoordinatorSpy,
			versionSupplier: versionSupplierSpy,
			remoteConfigManager: remoteConfigSpy,
			proofManager: proofManagerSpy,
			cryptoLibUtility: cryptoLibUtilitySpy
		)

		// Then
		expect(self.remoteConfigSpy.invokedUpdate) == true
		expect(self.proofManagerSpy.invokedFetchIssuerPublicKeys) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchState) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchStateParameters?.state) == LaunchState.internetRequired
		expect(self.cryptoLibUtilitySpy.invokedIsInitializedGetter) == false
	}

	/// Test internet required for the issuer public keys and the remote config
	func testInternetRequiredBothActions() {

		// Given
		remoteConfigSpy.stubbedUpdateCompletionResult = (.internetRequired, ())
		let error = NSError(
			domain: NSURLErrorDomain,
			code: URLError.notConnectedToInternet.rawValue
		)
		proofManagerSpy.stubbedFetchIssuerPublicKeysOnErrorResult = (error, ())
		cryptoLibUtilitySpy.stubbedIsInitialized = true

		// When
		sut = LaunchViewModel(
			coordinator: appCoordinatorSpy,
			versionSupplier: versionSupplierSpy,
			remoteConfigManager: remoteConfigSpy,
			proofManager: proofManagerSpy,
			cryptoLibUtility: cryptoLibUtilitySpy
		)

		// Then
		expect(self.remoteConfigSpy.invokedUpdate) == true
		expect(self.proofManagerSpy.invokedFetchIssuerPublicKeys) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchState) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchStateParameters?.state) == LaunchState.internetRequired
		expect(self.cryptoLibUtilitySpy.invokedIsInitializedGetter) == false
	}

	/// Test update required
	func testActionRequired() {

		// Given
		remoteConfigSpy.stubbedGetConfigurationResult = RemoteConfiguration(minVersion: "1.0", minVersionMessage: "remoteConfigSpy")
		let remoteConfig = remoteConfigSpy.getConfiguration()
		remoteConfigSpy.stubbedUpdateCompletionResult = (.actionRequired(remoteConfig), ())
		proofManagerSpy.shouldInvokeFetchIssuerPublicKeysOnCompletion = true
		cryptoLibUtilitySpy.stubbedIsInitialized = true

		// When
		sut = LaunchViewModel(
			coordinator: appCoordinatorSpy,
			versionSupplier: versionSupplierSpy,
			remoteConfigManager: remoteConfigSpy,
			proofManager: proofManagerSpy,
			cryptoLibUtility: cryptoLibUtilitySpy
		)

		// Then
		expect(self.remoteConfigSpy.invokedUpdate) == true
		expect(self.proofManagerSpy.invokedFetchIssuerPublicKeys) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchState) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchStateParameters?.state) == LaunchState.actionRequired(remoteConfig)
		expect(self.cryptoLibUtilitySpy.invokedIsInitializedGetter) == false
	}
	
	/// Test crypto library not initialized
	func test_cryptoLibNotInitialized() {

		// Given
		remoteConfigSpy.stubbedUpdateCompletionResult = (.cryptoLibNotInitialized, ())
		proofManagerSpy.shouldInvokeFetchIssuerPublicKeysOnCompletion = true
		cryptoLibUtilitySpy.stubbedIsInitialized = false

		// When
		sut = LaunchViewModel(
			coordinator: appCoordinatorSpy,
			versionSupplier: versionSupplierSpy,
			remoteConfigManager: remoteConfigSpy,
			proofManager: proofManagerSpy,
			cryptoLibUtility: cryptoLibUtilitySpy
		)

		// Then
		expect(self.remoteConfigSpy.invokedUpdate) == true
		expect(self.proofManagerSpy.invokedFetchIssuerPublicKeys) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchState) == true
		expect(self.appCoordinatorSpy.invokedHandleLaunchStateParameters?.state) == LaunchState.cryptoLibNotInitialized
		expect(self.cryptoLibUtilitySpy.invokedIsInitializedGetter) == true
	}
}
