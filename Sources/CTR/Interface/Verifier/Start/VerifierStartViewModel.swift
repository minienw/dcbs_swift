/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

enum VerifierStartResult {

	case userTappedProceedToScan

	case userTappedProceedToScanInstructions
    
    case userTappedProceedToScanInstructionsFromInvalidQR
}

class VerifierStartViewModel: Logging {

	var loggingCategory: String = "VerifierStartViewModel"

	weak private var coordinator: VerifierCoordinatorDelegate?
	weak private var cryptoManager: CryptoManaging?
	weak private var proofManager: ProofManaging?
    weak private var remoteConfigManager: RemoteConfigManaging?
	private var userSettings: UserSettingsProtocol

	// MARK: - Bindable properties

	/// The title of the scene
	@Bindable private(set) var title: String

	/// The title of the scene
	@Bindable private(set) var header: String

	/// The message of the scene
	@Bindable private(set) var message: String

	/// The title of the button
	@Bindable private(set) var primaryButtonTitle: String

	/// The title of the button
	@Bindable private(set) var showError: Bool = false

    // swiftlint:disable vertical_parameter_alignment
	/// Initializer
	/// - Parameters:
	///   - coordinator: the coordinator delegate
	///   - cryptoManager: the crypto manager
	///   - proofManager: the proof manager
	///   - userSettings: the user managed settings
	init(
		coordinator: VerifierCoordinatorDelegate,
		cryptoManager: CryptoManaging,
		proofManager: ProofManaging,
        remoteConfigManager: RemoteConfigManaging,
		userSettings: UserSettingsProtocol = UserSettings()) {

        self.remoteConfigManager = remoteConfigManager
		self.coordinator = coordinator
		self.cryptoManager = cryptoManager
		self.proofManager = proofManager
		self.userSettings = userSettings

		primaryButtonTitle = .verifierStartButtonTitle
		title = .verifierStartTitle
		header = .verifierStartHeader
		message = .verifierStartMessage
	}

	func primaryButtonTapped() {

		if userSettings.scanInstructionShown {

            updatePublicKeys()
            coordinator?.didFinish(.userTappedProceedToScan)
		} else {
			// Show the scan instructions the first time no matter what link was tapped
			userSettings.scanInstructionShown = true
			coordinator?.didFinish(.userTappedProceedToScanInstructions)
		}
	}
    
    func aboutTappd() {
        coordinator?.navigateToAbout()
    }

	func linkTapped() {

		coordinator?.didFinish(.userTappedProceedToScanInstructions)
	}

	/// Update the public keys
	private func updatePublicKeys() {

		// Fetch the public keys from the issuer
		proofManager?.fetchIssuerPublicKeys(onCompletion: nil, onError: nil)
        remoteConfigManager?.update { _ in }
	}
}
