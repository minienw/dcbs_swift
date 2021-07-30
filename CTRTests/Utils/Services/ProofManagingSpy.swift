/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class ProofManagingSpy: ProofManaging {

	required init() {}

	var invokedFetchIssuerPublicKeys = false
	var invokedFetchIssuerPublicKeysCount = 0
	var shouldInvokeFetchIssuerPublicKeysOnCompletion = false
	var stubbedFetchIssuerPublicKeysOnErrorResult: (Error, Void)?

	func fetchIssuerPublicKeys(
		onCompletion: (() -> Void)?,
		onError: ((Error) -> Void)?) {
		invokedFetchIssuerPublicKeys = true
		invokedFetchIssuerPublicKeysCount += 1
		if shouldInvokeFetchIssuerPublicKeysOnCompletion {
			onCompletion?()
		}
		if let result = stubbedFetchIssuerPublicKeysOnErrorResult {
			onError?(result.0)
		}
	}
}
