//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum ValueSetType: String {
    
    case testResult = "covid-19-lab-result"
    case countryCode = "country-2-codes"
    case testManufacturer = "covid-19-lab-test-manufacturer-and-name"
    case testType = "covid-19-lab-test-type"
    case targetedAgent = "disease-agent-targeted"
    case vaccineType = "sct-vaccines-covid-19"
    case vaccineAuthHolder = "vaccines-covid-19-auth-holders"
    case vaccineProduct = "vaccines-covid-19-names"
    
}
