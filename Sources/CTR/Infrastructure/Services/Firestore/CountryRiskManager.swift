//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

class CountryRiskManager {
    
    static let instance = CountryRiskManager()
    
    static let countryRisksCOllection = "countryRisks"
    
    let networkManager = Services.networkManager
    let cryptoManager = Services.cryptoManager
    
    var riskAreas: [CountryRisk]?
    
    @Keychain(name: "countryData", service: Constants.keychainService, clearOnReinstall: true)
    var countryData: CountryRiskResponse = .empty
    
    func fetchCountryRisks(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
        riskAreas = countryData.result
        networkManager.getFirebaseRiskAreas { result in
            switch result {
            case .success(let result):
                self.riskAreas = result.result
                self.countryData = result
                onSuccess()
            case .failure(let error):
                onFailure(error)
            }
        }
    }
    
    private struct Constants {
        static let keychainService = "CountryRiskManager\(Configuration().getEnvironment())\(ProcessInfo.processInfo.isTesting ? "Test" : "")"
    }
    
}
