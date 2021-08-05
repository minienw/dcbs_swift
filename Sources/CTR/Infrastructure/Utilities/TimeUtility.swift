//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

class TimeUtility {
    
    static func getTimeString(from: DateComponents, includeDays: Bool, includeHours: Bool, combine: Bool) -> String {
        var value = ""
        if let days = from.day, includeDays, days != 0 {
            value += (days == 1 ? "x_day" : "x_days").localized(params: days)
            if !combine {
                return value
            }
        }
        if let hours = from.hour, includeHours, hours != 0 {
            let hourStr = (hours == 1 ? "x_hour" : "x_hours").localized(params: hours)
            if value != "" {
                value += ", "
            }
            value += hourStr
            if !combine {
                return value
            }
        }
        return value
    }
    
}
