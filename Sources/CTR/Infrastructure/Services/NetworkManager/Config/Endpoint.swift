/*
 * Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

struct Path {

	/// The path components
    let components: [String]

	/// Initalizer
	/// - Parameter components: the path components
    init(components: String...) {
        self.components = Array(components)
    }
}

struct Endpoint {
	
	// MARK: - API
	
	/// Endpoint for the public keys
	static let publicKeys = Path(components: "dcbs", "public_keys")
	
	/// Endpoint for the remote configuration
	static let remoteConfiguration = Path(components: "dcbs", "config")
    
    /// Endpoint for the certlogic business rules
    static let businessRules = Path(components: "dcbs", "business_rules")
    
    /// Endpoint for the certlogic business rule value sets
    static let businessRuleValueSets = Path(components: "dcbs", "value_sets")
}
