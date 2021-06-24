//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum DCCFailableItem {
    
    case missingRequiredTest
    case testDateExpired(hours: Int)
    case testMustBeNegative
    
    func displayName() -> String {
        switch self {
        
            case .missingRequiredTest:
                return "rule_test_required".localized()
            case .testDateExpired(hours: let hours):
                return "rule_test_outdated".localized(params: hours)
            case .testMustBeNegative:
                return "rule_test_must_be_negative".localized()
        }
    }
    
}
