/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

extension FileManager {

	func addSkipBackupAttributeToItemAt(_ url: NSURL) throws {

		try url.setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
	}
}
