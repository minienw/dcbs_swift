//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

class AppleTestMessage: Codable {
    
    let appStoreConnectMessage: String
    
    static let july1st: TimeInterval = 1625090400
    
    static func isValid(qrData: String) -> Bool {
        let date = Date()
        if date.timeIntervalSince1970 >= july1st {
            return false
        }
        guard let jsonData = qrData.data(using: .utf8) else { return false }
        do {
            _ = try JSONDecoder().decode(AppleTestMessage.self, from: jsonData)
            return true
        } catch {
            return false
        }
    }
    
}
