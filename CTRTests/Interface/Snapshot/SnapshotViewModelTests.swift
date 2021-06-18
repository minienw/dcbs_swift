/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
@testable import CTR

class SnapshotViewModelTests: XCTestCase {

	var sut: SnapshotViewModel?

	var versionSupplierSpy = AppVersionSupplierSpy(version: "1.0.0", build: "test")

	override func setUp() {
		super.setUp()

		versionSupplierSpy = AppVersionSupplierSpy(version: "1.0.0", build: "test")

		sut = SnapshotViewModel(
			versionSupplier: versionSupplierSpy
		)
	}

	// MARK: Tests

	/// Test the initializer for the verifier
	func testInitVerifier() throws {

		// Given

		// When
		sut = SnapshotViewModel(
			versionSupplier: versionSupplierSpy
		)

		// Then
		let strongSut = try XCTUnwrap(sut)
		XCTAssertEqual(strongSut.title, .verifierLaunchTitle, "Title should match")
		XCTAssertEqual(strongSut.appIcon, .verifierAppIcon, "Icon should match")
	}
}
