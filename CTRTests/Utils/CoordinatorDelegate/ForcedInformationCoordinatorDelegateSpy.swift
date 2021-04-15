/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/
  
@testable import CTR
import XCTest

class ForcedInformationCoordinatorDelegateSpy: ForcedInformationCoordinatorDelegate {

	var invokedDidFinishConsent = false
	var invokedDidFinishConsentCount = 0
	var invokedDidFinishConsentParameters: (result: ForcedInformationResult, Void)?
	var invokedDidFinishConsentParametersList = [(result: ForcedInformationResult, Void)]()

	func didFinishConsent(_ result: ForcedInformationResult) {
		invokedDidFinishConsent = true
		invokedDidFinishConsentCount += 1
		invokedDidFinishConsentParameters = (result, ())
		invokedDidFinishConsentParametersList.append((result, ()))
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
}
