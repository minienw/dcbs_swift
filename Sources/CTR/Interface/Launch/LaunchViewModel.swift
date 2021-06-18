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
	private let cryptoLibUtility: CryptoLibUtilityProtocol

	private var isUpdatingConfiguration = false
	private var isUpdatingIssuerPublicKeys = false

	private var configStatus: LaunchState?
	private var issuerPublicKeysStatus: LaunchState?

	@Bindable private(set) var title: String
	@Bindable private(set) var message: String
	@Bindable private(set) var version: String
	@Bindable private(set) var appIcon: UIImage?

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
		remoteConfigManager: RemoteConfigManaging,
		proofManager: ProofManaging,
		cryptoLibUtility: CryptoLibUtilityProtocol = Services.cryptoLibUtility) {

		self.coordinator = coordinator
		self.versionSupplier = versionSupplier
		self.remoteConfigManager = remoteConfigManager
		self.proofManager = proofManager
		self.cryptoLibUtility = cryptoLibUtility

		title = .verifierLaunchTitle
		message = .verifierLaunchText
		appIcon = .verifierAppIcon

		version = String(
			format: .verifierLaunchVersion,
			versionSupplier.getCurrentVersion(),
			versionSupplier.getCurrentBuild()
		)

		updateDependencies()
	}

	/// Update the dependencies
	private func updateDependencies() {

		// TODO: Update
		updateConfiguration()
		updateKeys()
	}

	/// Update the configuration
	private func updateConfiguration() {

		// Execute once.
		guard !isUpdatingConfiguration else {
			return
		}

		isUpdatingConfiguration = true

		remoteConfigManager.update { [weak self] updateState in

			// TODO: Check
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
			self?.issuerPublicKeysStatus = .internetRequired
			self?.handleState()
		}
	}

	/// Handle the state of the updates
	private func handleState() {

		guard let configStatus = configStatus,
			  let issuerPublicKeysStatus = issuerPublicKeysStatus else {
			return
		}
		
		if case .actionRequired = configStatus {
			// show action
			coordinator?.handleLaunchState(configStatus)
		} else if configStatus == .internetRequired || issuerPublicKeysStatus == .internetRequired {
			// Show no internet
			coordinator?.handleLaunchState(.internetRequired)
		} else if !cryptoLibUtility.isInitialized {
			// Show crypto lib not initialized error
			coordinator?.handleLaunchState(.cryptoLibNotInitialized)
		} else {
			// Start application
			coordinator?.handleLaunchState(.noActionNeeded)
		}
	}
}
