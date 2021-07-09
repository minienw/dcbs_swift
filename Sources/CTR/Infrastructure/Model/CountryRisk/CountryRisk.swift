//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

enum CountryRiskPass: String {
    case pass = "pass"
    case inconclusive = "inconclusive"
    case nlRules = "nl_rules"
}

struct CountryRisk: Codable {
    
    let nameUs: String?
    let nameNl: String?
    let countryEn: String?
    let countryNl: String?
    let code: String?
    let color: String?
    let resultOnValidCode: String?
    let isColourCode: Bool?
   
    static var unselected: CountryRisk {
        return CountryRisk(nameUs: "country_unselected".localized(), nameNl: "country_unselected".localized(), countryEn: "country_unselected".localized(), countryNl: "country_unselected".localized(), code: "unselected", color: CountryColorCode.green.rawValue, resultOnValidCode: CountryRiskPass.inconclusive.rawValue, isColourCode: false)
    }
    
    static var other: CountryRisk {
        return CountryRisk(nameUs: "country_other".localized(), nameNl: "country_other".localized(), countryEn: "country_other".localized(), countryNl: "country_other".localized(), code: "other", color: CountryColorCode.green.rawValue, resultOnValidCode: CountryRiskPass.inconclusive.rawValue, isColourCode: false)
    }
    
    func isIndecisive() -> Bool {
        if getColourCode() == nil {
            return true
        }
        if getPassType() == nil {
            return true
        }
        if getPassType() == .inconclusive {
            return true
        }
        return false
    }
    
    func getColourCode() -> CountryColorCode? {
        return CountryColorCode(rawValue: color ?? "")
    }
    
    func getPassType() -> CountryRiskPass? {
        return CountryRiskPass(rawValue: resultOnValidCode ?? "")
    }
    
    func name() -> String? {
        let locale = Locale.current.languageCode
        if locale?.lowercased() == "nl" {
            return nameNl ?? countryNl ?? ""
        } else {
            return nameUs ?? countryEn ?? ""
        }
    }
    
    func section() -> String? {
        guard let name = name(), let first = name.first else { return nil }
        return "\(first)"
    }
    
    enum CodingKeys: String, CodingKey {

        case nameUs = "name_us"
        case nameNl = "name_nl"
        case code = "code"
        case color = "color"
        case resultOnValidCode = "result_on_valid_code"
        case countryEn = "country_EN"
        case countryNl = "country_NL"
        case isColourCode = "is_colour_code"
    }
}
