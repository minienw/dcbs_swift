//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

enum DCCFailableItem {
    
    case missingRequiredTest
    case testDateExpired(hours: Int)
    case testMustBeNegative
    case redNotAllowed
    case needFullVaccination
    case recoveryNotValid
    case requireSecondTest(hours: Int)
    
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
    
    case vaccinationMustBe14DaysOld
    
    case undecidableFrom
    
    case certLogicBusinessRule(description: String)
    
    case vocRequireSecondAntigen(hours: Int)
    case vocRequireSecondPCR(hours: Int)
    case vocRequirePCROrAntigen(singleHour: Int, pcrHours: Int, antigenHours: Int)
    
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
            case .requireSecondTest(hours: let hours):
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
                
            case .vaccinationMustBe14DaysOld:
                return "rule_vaccination_14_days".localized()
            case .undecidableFrom:
                return "result_inconclusive_message".localized()
                
            case .vocRequireSecondAntigen(let hours):
                return "voc_require_second_antigen".localized(params: hours)
            case .vocRequireSecondPCR(let hours):
                return "voc_require_second_pcr".localized(params: hours)
            case .vocRequirePCROrAntigen(let singleHour, let pcrHours, let antigenHours):
                return "voc_require_pcr_or_antigen".localized(params: singleHour, pcrHours, antigenHours)
                
            case .certLogicBusinessRule(let description):
                return description
        }
    }
    
    // swiftlint:disable switch_case_alignment
    func makesQRUndecided() -> Bool {
        switch self {
        case .undecidableFrom:
            return true
        default:
            return false
        }
    }
    
    func errorTextColour() -> UIColor {
        switch self {
        case .undecidableFrom:
            return Theme.colors.dark
        default:
            return Theme.colors.denied
        }
    }
    
}
