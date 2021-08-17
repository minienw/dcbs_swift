//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum VaccineProduct: String {
    
    case comirnaty = "EU/1/20/1528"
    case moderna = "EU/1/20/1507"
    case vaxzevria = "EU/1/21/1529"
    case janssen = "EU/1/20/1525"
    case cvncov = "CVnCoV"
    case sputnikv = "Sputnik-V"
    case convidecia = "Convidecia"
    case apiVacCorona = "EpiVacCorona"
    case bbibpCorv = "BBIBP-CorV"
    case inActivatedVeroCell = "Inactivated-SARS-CoV-2-Vero-Cell"
    case coronaVac = "CoronaVac"
    case covaxin = "Covaxin"
    case covishield = "Covishield"
    
    var displayName: String {
        switch self {
        
            case .comirnaty:
                return "Comirnaty"
            case .moderna:
                return "Moderna"
            case .vaxzevria:
                return "Vaxzevria"
            case .janssen:
                return "Janssen"
            case .cvncov:
                return "CVnCoV"
            case .sputnikv:
                return "Sputnik-V"
            case .convidecia:
                return "Convidecia"
            case .apiVacCorona:
                return "EpiVacCorona"
            case .bbibpCorv:
                return "BBIBP-CorV"
            case .inActivatedVeroCell:
                return "Inactivated SARS-CoV-2 (Vero Cell)"
            case .coronaVac:
                return "CoronaVac"
            case .covaxin:
                return "Covaxin (BBV152 A, B, C)"
            case .covishield:
                return "Covishield (ChAdOx1_nCoV-19)"
        }
    }
    
}
