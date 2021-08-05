/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import Clcore

/// The cryptography manager
class CryptoManager: CryptoManaging, Logging {
    
    /// Structure to hold key data
    private struct KeyData: Codable {
        
        /// The issuer public keys
        var issuerPublicKeys: Data?
        
        /// Empty key data
        static var empty: KeyData {
            return KeyData(issuerPublicKeys: nil)
        }
    }
    
    /// Structure to hold cryptography data
    private struct CryptoData: Codable {
        
        /// The key of the holder
        var holderSecretKey: Data?
        var nonce: String?
        var stoken: String?
        var ism: Data?
        var credential: Data?
        
        /// Empty crypto data
        static var empty: CryptoData {
            return CryptoData(holderSecretKey: nil, nonce: nil, stoken: nil, ism: nil, credential: nil)
        }
    }
    
    /// Array of constants
    private struct Constants {
        static let keychainService = "CryptoManager\(Configuration().getEnvironment())\(ProcessInfo.processInfo.isTesting ? "Test" : "")"
    }
    
    /// The crypto data stored in the keychain
    @Keychain(name: "cryptoData", service: Constants.keychainService, clearOnReinstall: true)
    private var cryptoData: CryptoData = .empty
    
    /// The key data stored in the keychain
    @Keychain(name: "keyData", service: Constants.keychainService, clearOnReinstall: true)
    private var keyData: KeyData = .empty
    
    private let cryptoLibUtility: CryptoLibUtility = Services.cryptoLibUtility
    
    /// Initializer
    required init() {
        
        // Initialize crypto library
        cryptoLibUtility.initialize()
    }
    
    /// Generate a string from a codable object
    /// - Parameter object: the object to flatten into a string
    /// - Returns: flattend object
    private func generateString<T>(object: T) -> String where T: Codable {
        
        if let data = try? JSONEncoder().encode(object),
           let convertedToString = String(data: data, encoding: .utf8) {
            return convertedToString
        }
        return ""
    }
    
    /// Do we have public keys
    /// - Returns: True if we do
    func hasPublicKeys() -> Bool {
        
        return keyData.issuerPublicKeys != nil
    }
    
    // MARK: - QR
    
    /// Verify the QR message
    /// - Parameter message: the scanned QR code
    /// - Returns: Attributes if the QR is valid or error string if not
    func verifyQRMessage(_ message: String) -> (DCCQR?, String?) {
        
        let proofQREncoded = message.data(using: .utf8)
        
        guard let result = MobilecoreVerify(proofQREncoded) else {
            return (attributes: nil, errorMessage: "could not verify QR")
        }
        
        guard result.error.isEmpty, let value = result.value else {
            self.logError("Error Proof: \(result.error)")
            return (attributes: nil, errorMessage: result.error)
        }
        do {
            let object = try JSONDecoder().decode(DCCQR.self, from: value)
            return (attributes: object, errorMessage: nil)
        } catch {
            self.logError("Error Deserializing \(CryptoAttributes.self): \(error)")
            return (attributes: nil, errorMessage: error.localizedDescription)
        }
    }
}
