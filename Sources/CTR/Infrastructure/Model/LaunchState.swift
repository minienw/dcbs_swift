/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

/// Should the app be updated?
enum LaunchState: Equatable {

	/// The app is fine.
	case noActionNeeded
	
	/// The crypto library needs to be initialized
	case cryptoLibNotInitialized

	// MARK: Equatable

	/// Equatable
	/// - Parameters:
	///   - lhs: the left hand side
	///   - rhs: the right hand side
	/// - Returns: True if both sides are equal
	static func == (lhs: LaunchState, rhs: LaunchState) -> Bool {
		switch (lhs, rhs) {
			case (noActionNeeded, noActionNeeded):
				return true
			case (.cryptoLibNotInitialized, cryptoLibNotInitialized):
				return true
			default:
				return false
		}
	}
}
