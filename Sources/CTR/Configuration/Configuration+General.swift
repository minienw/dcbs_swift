/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

protocol ConfigurationGeneralProtocol: AnyObject {

	/// Get the time for auto close
	/// - Returns: Time for auto close
	func getAutoCloseTime() -> TimeInterval

	/// Get the TTL for a test result warning
	/// - Returns: TTL for a test result warning
	func getTestResultWarningTTL() -> Int

	/// Get the Refresh Period for a QR
	/// - Returns: TTL for a QR
	func getQRRefreshPeriod() -> TimeInterval
}

// MARK: - ConfigurationGeneralProtocol

extension Configuration: ConfigurationGeneralProtocol {

	/// Get the time for auto close
	/// - Returns: Time for auto close
	func getAutoCloseTime() -> TimeInterval {
		guard let value = general["autoCloseTime"] as? TimeInterval else {
			fatalError("Configuration: No Auto Close Time provided")
		}
		return value
	}

	/// Get the TTL for a test result warning
	/// - Returns: TTL for a test result warning
	func getTestResultWarningTTL() -> Int {
		guard let value = general["testresultWarningTTL"] as? Int else {
			fatalError("Configuration: No Test Restult Warning TTL provided")
		}
		return value
	}

	/// Get the Refresh Period for a QR
	/// - Returns: TTL for a QR
	func getQRRefreshPeriod() -> TimeInterval {
		guard let value = general["QRRefresh"] as? TimeInterval else {
			fatalError("Configuration: No QR Refresh Period provided")
		}
		return value
	}
}
