/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class AppCoordinatorSpy: AppCoordinatorDelegate {

	var openUrlCalled = false

	func openUrl(_ url: URL) {

		openUrlCalled = true
	}
}
