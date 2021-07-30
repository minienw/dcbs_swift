/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class CryptoManagerSpy: CryptoManaging {

	required init() {}

	var invokedSetNonce = false
	var invokedSetNonceCount = 0
	var invokedSetNonceParameters: (nonce: String, Void)?
	var invokedSetNonceParametersList = [(nonce: String, Void)]()

	func setNonce(_ nonce: String) {
		invokedSetNonce = true
		invokedSetNonceCount += 1
		invokedSetNonceParameters = (nonce, ())
		invokedSetNonceParametersList.append((nonce, ()))
	}

	var invokedSetStoken = false
	var invokedSetStokenCount = 0
	var invokedSetStokenParameters: (stoken: String, Void)?
	var invokedSetStokenParametersList = [(stoken: String, Void)]()

	func setStoken(_ stoken: String) {
		invokedSetStoken = true
		invokedSetStokenCount += 1
		invokedSetStokenParameters = (stoken, ())
		invokedSetStokenParametersList.append((stoken, ()))
	}

	var invokedGetStoken = false
	var invokedGetStokenCount = 0
	var stubbedGetStokenResult: String!

	func getStoken() -> String? {
		invokedGetStoken = true
		invokedGetStokenCount += 1
		return stubbedGetStokenResult
	}

	var invokedHasPublicKeys = false
	var invokedHasPublicKeysCount = 0
	var stubbedHasPublicKeysResult: Bool! = false

	func hasPublicKeys() -> Bool {
		invokedHasPublicKeys = true
		invokedHasPublicKeysCount += 1
		return stubbedHasPublicKeysResult
	}

	var invokedVerifyQRMessage = false
	var invokedVerifyQRMessageCount = 0
	var invokedVerifyQRMessageParameters: (message: String, Void)?
	var invokedVerifyQRMessageParametersList = [(message: String, Void)]()
	var stubbedVerifyQRMessageResult: CryptoResult!

	func verifyQRMessage(_ message: String) -> CryptoResult {
		invokedVerifyQRMessage = true
		invokedVerifyQRMessageCount += 1
		invokedVerifyQRMessageParameters = (message, ())
		invokedVerifyQRMessageParametersList.append((message, ()))
		return stubbedVerifyQRMessageResult
	}
}
