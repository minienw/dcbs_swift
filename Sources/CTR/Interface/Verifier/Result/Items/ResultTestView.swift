//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ResultTestView: TMCBaseView {
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func setup(test: DCCTest, dateFormat: DateFormatter) {
        headerLabel.font = Theme.fonts.footnoteMontserrat
        resultLabel.font = Theme.fonts.subheadBoldMontserrat
        dateLabel.font = Theme.fonts.subheadBoldMontserrat
        resultLabel.text = test.getTestResult?.displayName ?? "item_unknown".localized()
        if let date = test.getDateOfTest() {
            dateLabel.text = dateFormat.string(from: date)
        } else {
            dateLabel.text = "item_unknown".localized()
        }
    }
    
}
