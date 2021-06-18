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

	internal var testProviders = [TestProvider]()
	
	/// Structure to hold proof data
	internal struct ProofData: Codable {
		
		/// The key of the holder
		var testTypes: [TestType]
		
		/// The test result
		var testWrapper: TestResultWrapper?
		
		/// The signed Wrapper
		var signedWrapper: SignedResponse?
		
		/// Empty crypto data
		static var empty: ProofData {
			return ProofData(testTypes: [], testWrapper: nil, signedWrapper: nil)
		}
	}

	/// Array of constants
	private struct Constants {
		static let keychainService = "ProofManager\(Configuration().getEnvironment())\(ProcessInfo.processInfo.isTesting ? "Test" : "")"
	}
	
	/// The proof data stored in the keychain
	@Keychain(name: "proofData", service: Constants.keychainService, clearOnReinstall: true)
	internal var proofData: ProofData = .empty

	@UserDefaults(key: "keysFetchedTimestamp", defaultValue: nil)
	var keysFetchedTimestamp: Date? // swiftlint:disable:this let_var_whitespace
	
	/// Initializer
	required init() {
		// Required by protocol
		
//		removeTestWrapper()
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
				case .success((_, let data)):
					
					// TODO: Update
					self?.keysFetchedTimestamp = Date()
					self?.cryptoLibUtility.store(data, for: .publicKeys)
					onCompletion?()
//					} else {
						// Loading of the public keys into the CL Library failed.
						// This is pretty much a dead end for the user.
//						onError?(NetworkResponseHandleError.invalidPublicKeys)
//					}
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
