/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

/// The manager of all the test provider proof data
class ProofManager: ProofManaging, Logging {
	
	var loggingCategory: String = "ProofManager"

	var remoteConfigManager: RemoteConfigManaging = Services.remoteConfigManager
	var networkManager: NetworkManaging = Services.networkManager
	var cryptoManager: CryptoManaging = Services.cryptoManager
	var cryptoLibUtility: CryptoLibUtility = Services.cryptoLibUtility

	/// Array of constants
	private struct Constants {
		static let keychainService = "ProofManager\(Configuration().getEnvironment())\(ProcessInfo.processInfo.isTesting ? "Test" : "")"
	}

	@UserDefaults(key: "keysFetchedTimestamp", defaultValue: nil)
	var keysFetchedTimestamp: Date? // swiftlint:disable:this let_var_whitespace
	
	/// Initializer
	required init() {
		// Required by protocol
	}
    
    func shouldUpdateKeys() -> Bool {
        guard let hoursSinceLast = hoursSinceFetched() else { return true }
        return hoursSinceLast >= 1
    }
    
    func shouldShowOutdatedKeysBanner() -> Bool {
        guard let hoursSinceLast = hoursSinceFetched() else { return true }
        return hoursSinceLast >= 24
    }
    
    func hoursSinceFetched() -> Int? {
        guard let lastFetch = keysFetchedTimestamp else { return nil }
        let now = Date()
        return Calendar.current.dateComponents([.hour], from: lastFetch, to: now).hour ?? 0
    }
	
	/// Fetch the issuer public keys
	/// - Parameters:
	///   - onCompletion: completion handler
	///   - onError: error handler
	func fetchIssuerPublicKeys(
		onCompletion: (() -> Void)?,
		onError: ((Error) -> Void)?) {
		
		let ttl = TimeInterval(remoteConfigManager.getConfiguration().configTTL ?? 0)
		
		networkManager.getPublicKeys { [weak self] resultwrapper in
			
			// Response is of type (Result<(IssuerPublicKeys, Data), NetworkError>)
			switch resultwrapper {
				case .success((let _, let data)):
					
                    self?.keysFetchedTimestamp = Date()
                    self?.cryptoLibUtility.store(data, for: .publicKeys)
                    onCompletion?()
				case let .failure(error):
					
					self?.logError("Error getting the issuers public keys: \(error)")
					if let lastFetchedTimestamp = self?.keysFetchedTimestamp,
					   lastFetchedTimestamp > Date() - ttl {
						self?.logInfo("Issuer public keys still within TTL")
						onCompletion?()
						
					} else {
						onError?(error)
					}
			}
		}
	}
	
	// MARK: - Helper methods
	
	private func generateString<T>(object: T) -> String where T: Codable {
		
		if let data = try? JSONEncoder().encode(object),
		   let convertedToString = String(data: data, encoding: .utf8) {
			logVerbose("ProofManager: Convert to \(convertedToString)")
			return convertedToString
		}
		return ""
	}
}
