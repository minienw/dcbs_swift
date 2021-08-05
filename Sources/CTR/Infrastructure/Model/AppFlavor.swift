/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

/// The Application flavor, used to determine if we are a holder or a verifier
enum AppFlavor: String {

	/// We are a verifier
	case verifier
	
	/// The flavor of the app
	static var flavor: AppFlavor {
		
        return .verifier
	}
}
