//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ResultRecoveryView: TMCBaseView {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var daysOldLabel: UILabel!
    
    func setup(recovery: DCCRecovery, dateFormat: DateFormatter) {
        
        dateLabel.font = Theme.fonts.footnoteMontserrat
        daysOldLabel.font = Theme.fonts.subheadBoldMontserrat
        label.font = Theme.fonts.subheadBoldMontserrat
        label.text = "\(recovery.getTargetedDisease?.displayName ?? recovery.targetedDisease) \("item_recovery_header".localized())"
        
        if let date = recovery.getDateOfFirstPositiveTest() {
            dateLabel.text = dateFormat.string(from: date)
        } else {
            dateLabel.text = recovery.dateOfFirstPositiveTest
        }
        if let age = recovery.getRecoveryAge() {
            daysOldLabel.text = TimeUtility.getTimeString(from: age, includeDays: true, includeHours: true, combine: false) + " " + "old".localized()
        } else {
            daysOldLabel.text = "cant_calculate_days_old".localized()
        }
    }
    
}
