//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum DCCTestResult: String {
    
    case notDetected = "260415000"
    case detected = "260373001"
    
    var displayName: String {
        switch self {
        
            case .notDetected:
                return "Negatief"
            case .detected:
                return "Positief"
        }
    }
    
}
