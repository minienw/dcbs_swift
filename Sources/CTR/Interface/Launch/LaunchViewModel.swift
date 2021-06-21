/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

class LaunchViewModel {

	private weak var coordinator: AppCoordinatorDelegate?

	private var versionSupplier: AppVersionSupplierProtocol
	private var remoteConfigManager: RemoteConfigManaging
	private var proofManager: ProofManaging
	private var userSettings: UserSettingsProtocol
	private let cryptoLibUtility: CryptoLibUtilityProtocol

	private var isUpdatingConfiguration = false
	private var isUpdatingIssuerPublicKeys = false

	private var configStatus: LaunchState?
	private var issuerPublicKeysStatus: LaunchState?
	private var flavor: AppFlavor

	@Bindable private(set) var title: String
	@Bindable private(set) var message: String
	@Bindable private(set) var version: String
	@Bindable private(set) var appIcon: UIImage?
	@Bindable private(set) var interruptForJailBreakDialog: Bool = false

	/// Initializer
	/// - Parameters:
	///   - coordinator: the coordinator delegate
	///   - versionSupplier: the version supplier
	///   - flavor: the app flavor (holder or verifier)
	///   - remoteConfigManager: the manager for fetching the remote configuration
	///   - proofManager: the proof manager for fetching the keys
	///   - jailBreakDetector: the detector for detecting jailbreaks
	///   - userSettings: the settings used for storing if the user has seen the jail break warning (if device is jailbroken)
	///   - cryptoLibUtility: the crypto library utility
	init(
		coordinator: AppCoordinatorDelegate,
		versionSupplier: AppVersionSupplierProtocol,
		flavor: AppFlavor,
		remoteConfigManager: RemoteConfigManaging,
		proofManager: ProofManaging,
		userSettings: UserSettingsProtocol = UserSettings(),
		cryptoLibUtility: CryptoLibUtilityProtocol = Services.cryptoLibUtility) {

		self.coordinator = coordinator
		self.versionSupplier = versionSupplier
		self.remoteConfigManager = remoteConfigManager
		self.proofManager = proofManager
		self.flavor = flavor
		self.userSettings = userSettings
		self.cryptoLibUtility = cryptoLibUtility

		title = .verifierLaunchTitle
		message = .verifierLaunchText
		appIcon = .verifierAppIcon

		let versionString: String = .verifierLaunchVersion
		version = String(
			format: versionString,
			versionSupplier.getCurrentVersion(),
			versionSupplier.getCurrentBuild()
		)

		if shouldShowJailBreakAlert() {
			// Interrupt, do not continu the flow
			interruptForJailBreakDialog = true
		} else {
			// Continu with the flow
			interruptForJailBreakDialog = false
			updateDependencies()
		}
	}

	/// Update the dependencies
	private func updateDependencies() {

		updateConfiguration()
		updateKeys()
	}

	private func shouldShowJailBreakAlert() -> Bool {

		return false
	}

	func userDismissedJailBreakWarning() {

		// Interruption is over
		interruptForJailBreakDialog = false
		// Warning has been shown, do not show twice
		userSettings.jailbreakWarningShown = true
		// Continu with flow
		updateDependencies()
	}

	/// Update the configuration
	private func updateConfiguration() {

		// Execute once.
		guard !isUpdatingConfiguration else {
			return
		}

		isUpdatingConfiguration = true

		remoteConfigManager.update { [weak self] updateState in

			self?.configStatus = updateState
			self?.isUpdatingConfiguration = false
			self?.handleState()
		}
	}

	/// Update the Issuer Public keys
	private func updateKeys() {

		// Execute once.
		guard !isUpdatingIssuerPublicKeys else {
			return
		}

		isUpdatingIssuerPublicKeys = true

		// Fetch the issuer Public keys
		proofManager.fetchIssuerPublicKeys { [weak self] in

			self?.isUpdatingIssuerPublicKeys = false
			self?.issuerPublicKeysStatus = .noActionNeeded
			self?.handleState()

		} onError: { [weak self] error in

			self?.isUpdatingIssuerPublicKeys = false
            /// In DCC scanner app, we don't block the user when no internet is available
			self?.issuerPublicKeysStatus = .noActionNeeded
			self?.handleState()
		}
	}

	/// Handle the state of the updates
	private func handleState() {
		
		if !cryptoLibUtility.isInitialized {
			// Show crypto lib not initialized error
			coordinator?.handleLaunchState(.cryptoLibNotInitialized)
		} else {
			// Start application
			coordinator?.handleLaunchState(.noActionNeeded)
		}
	}
}
