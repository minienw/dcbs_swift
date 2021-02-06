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
}

extension NetworkResponseHandleError {
	var asNetworkError: NetworkError {
		switch self {
			case .cannotDeserialize:
				return .invalidResponse
			case .cannotUnzip:
				return .invalidResponse
			case .invalidSignature:
				return .invalidResponse
		}
	}
}

enum HTTPHeaderKey: String {
    case contentType = "Content-Type"
    case acceptedContentType = "Accept"
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
	/// - Parameter configuration: the network configuration
    init(configuration: NetworkConfiguration)

	/// Get the remote configuration
	/// - Parameter completion: completion handler
    func getRemoteConfiguration(completion: @escaping (Result<RemoteConfiguration, NetworkError>) -> Void)

	/// Get the nonce
	/// - Parameter completion: completion handler
	func getNonce(completion: @escaping (Result<NonceEnvelope, NetworkError>) -> Void)

	/// Fetch the test results with issue signature message
	/// - Parameters:
	///   - dictionary: dictionary
	///   - completionHandler: the completion handler
	func fetchTestResultsWithISM(
		dictionary: [String: AnyObject],
		completion: @escaping (Result<(URLResponse, Data), NetworkError>) -> Void)
}