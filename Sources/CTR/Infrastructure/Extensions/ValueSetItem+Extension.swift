//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

extension ValueSetItem {
    static func fromDictionary(dictionary: [String: Any]) -> ValueSetItem? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(Self.self, from: jsonData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
