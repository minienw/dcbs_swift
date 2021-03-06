/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

protocol ProofManagingDelegate: AnyObject {
    func didStartKeyFetch()
    func didEndKeyFetch()
}

protocol ProofManaging: AnyObject {

	init()

	/// Fetch the issuer public keys
	/// - Parameters:
	///   - onCompletion: completion handler
	///   - onError: error handler
	func fetchIssuerPublicKeys(
		onCompletion: (() -> Void)?,
		onError: ((Error) -> Void)?)
    
    func lastUpdateTime() -> Date?
    func shouldShowOutdatedKeysBanner() -> Bool
    func setDelegate(delegate: ProofManagingDelegate)
    func shouldUpdateKeys() -> Bool
}

enum ProofError: Error {

	case invalidUrl

	case missingParams
}
