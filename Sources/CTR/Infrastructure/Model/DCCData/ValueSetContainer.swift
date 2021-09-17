//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

class ValueSetContainer: Codable {
    let key: String
    let items: [String: ValueSetItem]
    
    init(key: String, items: [String: ValueSetItem]) {
        self.key = key
        self.items = items
    }
}
