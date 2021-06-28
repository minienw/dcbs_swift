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
        headerLabel.font = Theme.fonts.subheadBoldMontserrat
        resultLabel.font = Theme.fonts.subheadBoldMontserrat
        dateLabel.font = Theme.fonts.footnoteMontserrat
        headerLabel.text = "item_test_header".localized(params: test.getTestResult?.displayNameAdjective ?? "item_unknown".localized())
        resultLabel.text = test.getAgeString()
        if let date = test.getDateOfTest() {
            dateLabel.text = dateFormat.string(from: date)
        } else {
            dateLabel.text = test.dateOfSampleCollection
        }
    }
    
}
