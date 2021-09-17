/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

/// The access options
enum AccessAction {

	case verified
	case denied
	case demo
}

class VerifierResultViewModel: PreventableScreenCapture, Logging {

    static var timeUntilAutoClose = 60
    
	/// The logging category
	var loggingCategory: String = "VerifierResultViewModel"

	/// Coordination Delegate
	weak var coordinator: (VerifierCoordinatorDelegate & Dismissable & OpenUrlProtocol)?

	/// The configuration
	private var configuration: ConfigurationGeneralProtocol = Configuration()

	/// The scanned attributes
	internal var cryptoResults: (attributes: DCCQR?, errorMessage: String?)

	/// A timer auto close the scene
	private var autoCloseTimer: Timer?
    
    private var proofManager: ProofManaging?
    
    private var remoteConfigManager: RemoteConfigManaging

	// MARK: - Bindable properties

	/// The title of the scene
	@Bindable private(set) var title: String = ""

	/// The message of the scene
	@Bindable private(set) var message: String?

	/// The first name of the holder
	@Bindable private(set) var firstName: String = "-"

	/// The last name of the holder
	@Bindable private(set) var lastName: String = "-"

	/// The birth day of the holder
	@Bindable private(set) var dayOfBirth: String = "-"

	/// The birth mont of the holder
	@Bindable private(set) var monthOfBirth: String = "-"

	/// The linked message of the scene
	@Bindable var linkedMessage: String?

	/// The title of the button
	@Bindable private(set) var primaryButtonTitle: String

	/// Allow Access?
	@Bindable var allowAccess: AccessAction = .denied
    
    /// Current auto close timer ticks
    @Bindable var autoCloseTicks = 0

	/// Initialzier
	/// - Parameters:
	///   - coordinator: the dismissable delegate
	///   - scanResults: the decrypted attributes
	///   - maxValidity: the maximum validity of a test in hours
    init(coordinator: (VerifierCoordinatorDelegate & Dismissable & OpenUrlProtocol), proofManager: ProofManaging, remoteConfigManager: RemoteConfigManaging, cryptoResults: (DCCQR?, String?), maxValidity: Int) {

		self.coordinator = coordinator
		self.cryptoResults = cryptoResults
        self.proofManager = proofManager
        self.remoteConfigManager = remoteConfigManager

		primaryButtonTitle = .verifierResultButtonTitle
		super.init()

		checkAttributes()
		startAutoCloseTimer()
	}

	override func addObservers() {

		// super will handle the PreventableScreenCapture observers
		super.addObservers()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(closeScene),
			name: UIApplication.didEnterBackgroundNotification,
			object: nil
		)
	}

	deinit {

		stopAutoCloseTimer()
	}

	/// Check the attributes
	internal func checkAttributes() {
		
		guard let attributes = cryptoResults.attributes else {
			allowAccess = .denied
			showAccessDeniedInvalidQR()
            proofManager?.fetchIssuerPublicKeys(onCompletion: nil, onError: nil)
            remoteConfigManager.update { _ in }
			return
		}
		
		if attributes.isDomesticDcc {
			// Domestic issued DCC is not valid
			allowAccess = .denied
			showAccessDeniedDomesticDcc()
		} else if attributes.isSpecimen {
			allowAccess = .demo
			showAccessDemo()
		} else {
			allowAccess = .verified
			showAccessAllowed()
		}
	}

	/// Determine the value for display
	/// - Parameter value: the crypto attribute value
	/// - Returns: the value of the attribute, or a hyphen if empty
	private func determineAttributeValue(_ value: String?) -> String {

		if let value = value, !value.isEmpty {
			return value
		}
		return "-"
	}

	/// Formatter to print
	private lazy var printDateFormatter: DateFormatter = {

		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(identifier: "Europe/Amsterdam")
		dateFormatter.dateFormat = "E d MMMM HH:mm:ss"
		return dateFormatter
	}()

	private func showAccessAllowed() {

		title = .verifierResultAccessTitle
		message = nil
	}

	private func showAccessDeniedInvalidQR() {

		title = .verifierResultDeniedTitle
		message = .verifierResultDeniedMessage
		linkedMessage = .verifierResultDeniedLink
	}

	private func showAccessDemo() {

		title = .verifierResultDemoTitle
		message = nil
	}
	
	private func showAccessDeniedDomesticDcc() {
		
		title = .verifierResultDeniedRegionTitle
		message = .verifierResultDeniedRegionMessage
	}

	func dismiss() {

		stopAutoCloseTimer()
		coordinator?.navigateToVerifierWelcome()
	}

    func scanAgain() {

		stopAutoCloseTimer()
        coordinator?.navigateToScan()
    }
    
    func navigateToDeniedHelp() {
        coordinator?.didFinish(.userTappedProceedToScanInstructionsFromInvalidQR)
    }

	// MARK: - AutoCloseTimer

	/// Start the auto close timer, close after configuration.getAutoCloseTime() seconds
	func startAutoCloseTimer() {

		guard autoCloseTimer == nil else {
			return
		}

		autoCloseTimer = Timer.scheduledTimer(
			timeInterval: 1,
			target: self,
			selector: (#selector(autoCloseTick)),
			userInfo: nil,
			repeats: true
		)
	}

	func stopAutoCloseTimer() {

		autoCloseTimer?.invalidate()
		autoCloseTimer = nil
	}
    
    func isAutoCloseTimerActive() -> Bool {
        return autoCloseTimer != nil
    }

	@objc private func autoCloseTick() {

        if autoCloseTicks >= VerifierResultViewModel.timeUntilAutoClose {
            closeScene()
            UIAccessibility.post(notification: .announcement, argument: "accessibility_result_timer_finished".localized())
        } else {
            autoCloseTicks += 1
        }
	}
    
    @objc func closeScene() {
        logInfo("Auto closing the result view")
        stopAutoCloseTimer()
        dismiss()
    }
}
