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
    case redNotAllowed
    case needFullVaccination
    case recoveryNotValid
    case requireSecondTest(hours: Int, type: DCCTestType)
    
    func displayName() -> String {
        switch self {
        
            case .missingRequiredTest:
                return "rule_test_required".localized()
            case .testDateExpired(hours: let hours):
                return "rule_test_outdated".localized(params: hours)
            case .testMustBeNegative:
                return "rule_test_must_be_negative".localized()
            case .redNotAllowed:
                return "rule_red_not_allowed".localized()
            case .needFullVaccination:
                return "rule_full_vaccination_required".localized()
            case .recoveryNotValid:
                return "rule_recovery_not_valid".localized()
            case .requireSecondTest(hours: let hours, type: let type):
                return "rule_require_second_test".localized(params: type.displayName, hours)
        }
    }
    
}
