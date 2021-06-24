//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class SelectedCountryView: TMCBaseView {
    
    @IBOutlet var destinationTitleLabel: UILabel!
    @IBOutlet var departureTitleLabel: UILabel!
    @IBOutlet var departureLabel: UILabel!
    @IBOutlet var destiantionLabel: UILabel!
    
    var onTappedDeparture: (() -> Void)?
    var onTappedDestination: (() -> Void)?
    
    func setup(departure: String, destination: String) {
        
        departureTitleLabel.font = Theme.fonts.caption1Montserrat
        departureLabel.font = Theme.fonts.caption1Montserrat
        
        destiantionLabel.font = Theme.fonts.caption1Montserrat
        destinationTitleLabel.font = Theme.fonts.caption1Montserrat
        departureLabel.text = departure == "" ? "country_unselected".localized() : CountryColorCode(rawValue: departure)?.rawValue.localized() ?? "country_unselected".localized()
        destiantionLabel.text = destination == "" ? "country_unselected".localized() :
            ADCountryPicker.countryForCode(code: destination).name
    }
    
    @IBAction func departureTapped(_ sender: Any) {
        onTappedDeparture?()
    }
    
    @IBAction func destinationTapped(_ sender: Any) {
        onTappedDestination?()
    }
    
}
