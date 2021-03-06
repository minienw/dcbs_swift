//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

struct CountryRiskResponse: Codable {
    let result: [CountryRisk]
    
    /// Empty crypto data
    static var empty: CountryRiskResponse {
        return CountryRiskResponse(result: [])
    }
}
