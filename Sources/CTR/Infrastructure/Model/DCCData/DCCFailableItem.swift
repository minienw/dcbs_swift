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
    
    case invalidTestResult
    case invalidTestType
    case invalidTargetDisease
    case invalidVaccineHolder
    case invalidVaccineType
    case invalidVaccineProduct
    case dateOfBirthOutOfRange
    case invalidCountryCode
    
    case invalidDateOfBirth
    case invalidVaccineDate
    case invalidTestDate
    case invalidRecoveryFirstTestDate
    case invalidRecoveryFromDate
    case invalidRecoveryToDate
    
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
                return "rule_require_second_test".localized(params: hours)
            case .invalidTestResult:
                return "rule_invalid_test_result".localized()
            case .invalidTestType:
                return "rule_invalid_test_type".localized()
            case .invalidTargetDisease:
                return "rule_invalid_target_disease".localized()
            case .invalidVaccineHolder:
                return "rule_invalid_vaccine_holder".localized()
            case .invalidVaccineType:
                return "rule_invalid_vaccine_type".localized()
            case .invalidVaccineProduct:
                return "rule_invalid_vaccine_product".localized()
            case .dateOfBirthOutOfRange:
                return "rule_date_of_birth_out_of_range".localized()
            case .invalidCountryCode:
                return "rule_invalid_country_code".localized()
                
            case .invalidDateOfBirth:
                return "rule_invalid_date_of_birth".localized()
            case .invalidVaccineDate:
                return "rule_invalid_vaccine_date".localized()
            case .invalidTestDate:
                return "rule_invalid_test_date".localized()
            case .invalidRecoveryFirstTestDate:
                 return "rule_invalid_recovery_first_test_date".localized()
            case .invalidRecoveryFromDate:
                return "rule_invalid_recovery_from_date".localized()
            case .invalidRecoveryToDate:
                return "rule_invalid_recovery_to_date".localized()
        }
    }
    
}
