/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

/// The manager of all the test provider proof data
class BusinessRulesManager: /*ProofManaging,*/ Logging {
    
    var loggingCategory: String = "BusinessRulesManager"

    var networkManager: NetworkManaging = Services.networkManager
    
    /// Array of constants
    private struct Constants {
        static let keychainService = "BusinessRulesManager\(Configuration().getEnvironment())\(ProcessInfo.processInfo.isTesting ? "Test" : "")"
    }
    
    @Keychain(name: "businessRules", service: Constants.keychainService, clearOnReinstall: true)
    var businessRules: [Rule] = []
    
    @Keychain(name: "valueSets", service: Constants.keychainService, clearOnReinstall: true)
    var valueSets: [String: [String]] = [:]
    
    /// Initializer
    required init() {
        // Required by protocol
        loadSchema()
    }
    
    var schema: String?
    
    func loadSchema() {
        guard let path = Bundle.main.path(forResource: "dcc-schema", ofType: "json") else { return }
        schema = try? String(contentsOfFile: path)
    }
    
    func update(
        onCompletion: (() -> Void)?,
        onError: ((Error) -> Void)?) {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        networkManager.getBusinessRules { [weak self] resultwrapper in
            
            switch resultwrapper {
                case .success((let result, _)):
                    dispatchGroup.leave()
                    self?.businessRules = result
                    onCompletion?()
                case let .failure(error):
                    dispatchGroup.leave()
                    
                    self?.logError("Error getting the business rules: \(error)")
                    onError?(error)
            }
        }
        
        networkManager.getValueSets { [weak self] resultwrapper in
            
            switch resultwrapper {
                case .success((let result)):
                    dispatchGroup.leave()
            
                    self?.valueSets = result
                    onCompletion?()
                case let .failure(error):
                    dispatchGroup.leave()
                    
                    self?.logError("Error getting the data sets: \(error)")
                    onError?(error)
            }
        }
        dispatchGroup.notify(queue: .main) {
            onCompletion?()
        }
    }
    
}
