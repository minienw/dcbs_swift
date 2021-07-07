//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class TrustListStatusView: TMCBaseView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        return formatter
    }
    
    func setup(time: Date?) {
        titleLabel.font = Theme.fonts.footnote
        timeLabel.font = Theme.fonts.subheadBoldMontserrat
        guard let time = time else {
            timeLabel.text = "item_unknown".localized()
            return
        }
        timeLabel.text = dateFormatter.string(from: time)
    }
}
