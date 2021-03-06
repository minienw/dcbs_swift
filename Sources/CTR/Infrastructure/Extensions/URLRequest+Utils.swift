/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

extension URLRequest {

	/// Add headers to an URLRequest
	/// - Parameter headers: the headers to add
	mutating func addHeaders(_ headers: [String: String?]) {
		
		for (key, value) in headers {
			setValue(value, forHTTPHeaderField: key)
		}
	}
}
