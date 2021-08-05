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
    @IBOutlet var daysOldLabel: UILabel!
    
    func setup(vaccine: DCCVaccine, dateFormat: DateFormatter) {
        doseLabel.font = Theme.fonts.footnoteMontserrat
        productLabel.font = Theme.fonts.subheadBoldMontserrat
        dateLabel.font = Theme.fonts.footnoteMontserrat
        daysOldLabel.font = Theme.fonts.subheadBoldMontserrat

        doseLabel.text = "vaccin_header".localized(params: vaccine.getVaccineProduct?.displayName ?? vaccine.vaccineMedicalProduct, vaccine.doseNumber, vaccine.totalSeriesOfDoses)
        productLabel.text = vaccine.isFullyVaccinated() ? "vaccin_complete".localized() : "vaccin_incomplete".localized()
        productLabel.textColor = vaccine.isFullyVaccinated() ? Theme.colors.access : Theme.colors.denied
        if let date = vaccine.getDateOfVaccination() {
            dateLabel.text = dateFormat.string(from: date)
        } else {
            dateLabel.text = vaccine.dateOfVaccination
        }
        if let age = vaccine.getVaccinationAge() {
            daysOldLabel.text = TimeUtility.getTimeString(from: age, includeDays: true, includeHours: true, combine: false) + " " + "old".localized()
        } else {
            daysOldLabel.text = "cant_calculate_days_old".localized()
        }
    }
    
}
