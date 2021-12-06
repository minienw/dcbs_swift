//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class AccessibilityUtility {
    
    static func requestFocus(to: Any?, delay: Int = 30) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) {
            UIAccessibility.post(notification: .layoutChanged, argument: to)
        }
    }
    
}
