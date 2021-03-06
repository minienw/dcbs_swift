/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class VerifierCoordinatorDelegateSpy: VerifierCoordinatorDelegate, OpenUrlProtocol, Dismissable {

	var invokedNavigateToVerifierWelcome = false
	var invokedNavigateToVerifierWelcomeCount = 0

	func navigateToVerifierWelcome() {
		invokedNavigateToVerifierWelcome = true
		invokedNavigateToVerifierWelcomeCount += 1
	}

	var invokedDidFinish = false
	var invokedDidFinishCount = 0

	func didFinish() {
		invokedDidFinish = true
		invokedDidFinishCount += 1
	}

	var invokedNavigateToScan = false
	var invokedNavigateToScanCount = 0

	func navigateToScan() {
		invokedNavigateToScan = true
		invokedNavigateToScanCount += 1
	}

	var invokedNavigateToScanResult = false
	var invokedNavigateToScanResultCount = 0
	var invokedNavigateToScanResultParameters: (scanResult: DCCQR, Void)?
	var invokedNavigateToScanResultParametersList = [(scanResult: CryptoResult, Void)]()

	func navigateToScanResult(_ scanResult: DCCQR) {
		invokedNavigateToScanResult = true
		invokedNavigateToScanResultCount += 1
		invokedNavigateToScanResultParameters = (scanResult, ())
		invokedNavigateToScanResultParametersList.append((scanResult, ()))
	}

	var invokedDisplayContent = false
	var invokedDisplayContentCount = 0
	var invokedDisplayContentParameters: (title: String, content: [Content])?
	var invokedDisplayContentParametersList = [(title: String, content: [Content])]()

	func displayContent(title: String, content: [Content]) {
		invokedDisplayContent = true
		invokedDisplayContentCount += 1
		invokedDisplayContentParameters = (title, content)
		invokedDisplayContentParametersList.append((title, content))
	}

	var invokedOpenUrl = false
	var invokedOpenUrlCount = 0
	var invokedOpenUrlParameters: (url: URL, inApp: Bool)?
	var invokedOpenUrlParametersList = [(url: URL, inApp: Bool)]()

	func openUrl(_ url: URL, inApp: Bool) {
		invokedOpenUrl = true
		invokedOpenUrlCount += 1
		invokedOpenUrlParameters = (url, inApp)
		invokedOpenUrlParametersList.append((url, inApp))
	}

	var invokedDismiss = false
	var invokedDismissCount = 0

	func dismiss() {
		invokedDismiss = true
		invokedDismissCount += 1
	}
}
