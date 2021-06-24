//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ResultVaccineView: TMCBaseView {
    
    @IBOutlet var doseLabel: UILabel!
    @IBOutlet var productLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func setup(vaccine: DCCVaccine, dateFormat: DateFormatter) {
        doseLabel.font = Theme.fonts.footnoteMontserrat
        productLabel.font = Theme.fonts.subheadBoldMontserrat
        dateLabel.font = Theme.fonts.subheadBoldMontserrat
        doseLabel.text = "item_dose_x_x".localized(params: vaccine.doseNumber, vaccine.totalSeriesOfDoses)
        productLabel.text = vaccine.getVaccineProduct?.displayName ?? ""
        if let date = vaccine.getDateOfVaccination() {
            dateLabel.text = dateFormat.string(from: date)
        } else {
            dateLabel.text = "item_unknown".localized()
        }
    }
    
}
