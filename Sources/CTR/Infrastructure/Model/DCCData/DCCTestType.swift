//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum DCCTestType: String {
    
    case nucleidAcid = "LP6464-4"
    case rapidImmune = "LP217198-3"
    
    var displayName: String {
        switch self {
        
            case .nucleidAcid:
                return "Nucleic acid amplification with probe detection"
            case .rapidImmune:
                return "Rapid immunoassay"
        }
    }
    
}
