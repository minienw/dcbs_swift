/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum NetworkResponseHandleError: Error {
	case cannotUnzip
	case invalidSignature
	case cannotDeserialize
	case invalidPublicKeys
	case unexpectedCondition
}

enum NetworkError: Error {
	case invalidRequest
	case serverNotReachable
	case invalidResponse
	case responseCached
	case serverError
	case resourceNotFound
	case encodingError
	case redirection
	case serverBusy
}

extension NetworkResponseHandleError {
	
	var asNetworkError: NetworkError {
		return .invalidResponse
	}
}

enum HTTPHeaderKey: String {
	case contentType = "Content-Type"
	case acceptedContentType = "Accept"
	case authorization = "Authorization"
	case tokenProtocolVersion = "CoronaCheck-Protocol-Version"
}

enum HTTPContentType: String {
	case all = "*/*"
	case json = "application/json"
}

/// - Tag: NetworkManaging
protocol NetworkManaging {
	
	/// The network configuration
	var networkConfiguration: NetworkConfiguration { get }
	
	/// Initializer
	/// - Parameters:
	///   - configuration: the network configuration
	///   - validator: the signature validator
	init(configuration: NetworkConfiguration, validator: CryptoUtilityProtocol)
	
	/// Get the public keys
	/// - Parameter completion: completion handler
	func getPublicKeys(completion: @escaping (Result<(IssuerPublicKeys, Data), NetworkError>) -> Void)
	
	/// Get the remote configuration
	/// - Parameter completion: completion handler
	func getRemoteConfiguration(completion: @escaping (Result<(RemoteConfiguration, Data), NetworkError>) -> Void)
    
    func getBusinessRules(completion: @escaping (Result<([Rule], Data), NetworkError>) -> Void)
    
    func getCustomBusinessRules(completion: @escaping (Result<([Rule], Data), NetworkError>) -> Void)
    
    func getValueSets(completion: @escaping (Result<([String: [String]], [ValueSetContainer]), NetworkError>) -> Void)
}

struct SignedResponse: Codable, Equatable {
	
	/// The payload
	let payload: String
	
	/// The signature
	let signature: String
	
	// Key mapping
	enum CodingKeys: String, CodingKey {
		
		case payload
		case signature
	}
}
