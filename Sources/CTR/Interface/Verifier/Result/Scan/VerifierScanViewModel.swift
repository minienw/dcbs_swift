/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit
import AVFoundation

class VerifierScanViewModel: ScanPermissionViewModel {

	/// The crypto manager
	weak var cryptoManager: CryptoManaging?

	/// Coordination Delegate
	weak var theCoordinator: (VerifierCoordinatorDelegate & Dismissable & OpenUrlProtocol)?

	// MARK: - Bindable properties

	/// The title of the scene
	@Bindable private(set) var title: String

	/// The message of the scene
	@Bindable private(set) var message: String

	/// The accessibility labels for the torch
	@Bindable private(set) var torchLabels: [String]

	/// Start scanning
	@Bindable private(set) var startScanning: Bool = false

	/// Initializer
	/// - Parameters:
	///   - coordinator: the coordinator delegate
	///   - cryptoManager: the crypto manager
	init(
		coordinator: (VerifierCoordinatorDelegate & Dismissable & OpenUrlProtocol),
		cryptoManager: CryptoManaging) {

		self.theCoordinator = coordinator
		self.cryptoManager = cryptoManager

		self.title = .verifierScanTitle
		self.message = .verifierScanMessage
		self.torchLabels = [.verifierScanTorchEnable, .verifierScanTorchDisable]

		super.init(coordinator: coordinator)
	}

	/// Parse the scanned QR-code
	/// - Parameter code: the scanned code
	func parseQRMessage(_ message: String) {
        
        let environment = Bundle.main.infoDictionary?["NETWORK_CONFIGURATION"] as? String
        if environment == "ACC" || environment == "Test" || environment == "Development" {
            if let jsonData = message.data(using: .utf8), let dcc = try? JSONDecoder().decode(DCCQR.self, from: jsonData) {
                theCoordinator?.navigateToScanResult((dcc, nil))
                return
            }
        }
        
		if let cryptoResults = cryptoManager?.verifyQRMessage(message) {
			theCoordinator?.navigateToScanResult(cryptoResults)
		}
	}

	func dismiss() {

		theCoordinator?.navigateToVerifierWelcome()
	}
}
