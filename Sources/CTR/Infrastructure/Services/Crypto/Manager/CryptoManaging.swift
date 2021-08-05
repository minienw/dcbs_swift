/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

typealias CryptoResult = (attributes: CryptoAttributes?, errorMessage: String?)

struct PrepareIssueEnvelope: Codable {

    let prepareIssueMessage: String
    let stoken: String
}

struct CryptoAttributes: Codable {
    
    let birthDay: String?
    let birthMonth: String?
    let credentialVersion: String?
    let domesticDcc: String?
    let firstNameInitial: String?
    let lastNameInitial: String?
    let specimen: String?
    
    enum CodingKeys: String, CodingKey {
        
        case birthDay
        case birthMonth
        case credentialVersion
        case domesticDcc = "isNLDCC"
        case firstNameInitial
        case lastNameInitial
        case specimen = "isSpecimen"
    }
    
    var isDomesticDcc: Bool {
        
        return domesticDcc == "1"
    }
    
    var isSpecimen: Bool {
        
        return specimen == "1"
    }
}

struct IssuerDomesticPublicKey: Codable {
    
    let identifier: String
    let publicKey: String
    
    enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case publicKey = "public_key"
    }
}

struct IssuerPublicKeys: Codable {
    
    let clKeys: [IssuerDomesticPublicKey]
    
    enum CodingKeys: String, CodingKey {
        
        case clKeys = "cl_keys"
    }
}

protocol CryptoManaging: AnyObject {
    
    init()
    
    // MARK: Public Keys
    
    /// Do we have public keys
    /// - Returns: True if we do
    func hasPublicKeys() -> Bool
    
    // MARK: QR
    
    /// Verify the QR message
    /// - Parameter message: the scanned QR code
    /// - Returns: Attributes if the QR is valid or error string if not
    func verifyQRMessage(_ message: String) -> (DCCQR?, String?)
}

/// The errors returned by the crypto library
enum CryptoError: Error {

    case keyMissing
    case credentialCreateFail(reason: String)
    case unknown
}
