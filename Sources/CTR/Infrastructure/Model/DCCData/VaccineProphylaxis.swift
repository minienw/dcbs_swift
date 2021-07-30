//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum VaccineProphylaxis: String {
    
    case MRNA = "1119349007"
    case antigen = "1119305005"
    case covid19Vaccines = "J07BX03"
    
    var displayName: String {
        switch self {
        
            case .MRNA:
                return "mRNA vaccine"
            case .antigen:
                return "Antigen vaccine"
            case .covid19Vaccines:
                return "covid-19 vaccines"
        }
    }
    
}
