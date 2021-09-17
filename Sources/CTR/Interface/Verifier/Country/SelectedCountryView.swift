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
    
    @IBOutlet var departureContainer: CustomView!
    @IBOutlet var destinationContainer: CustomView!
    
    @IBOutlet var destinationTitleLabel: UILabel!
    @IBOutlet var departureTitleLabel: UILabel!
    @IBOutlet var departureLabel: UILabel!
    @IBOutlet var destiantionLabel: UILabel!
    @IBOutlet var riskLabel: UILabel!
    
    var onTappedDeparture: (() -> Void)?
    var onTappedDestination: (() -> Void)?
    
    override func initLayout() {
        super.initLayout()
        departureContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(departureTapped)))
        destinationContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(destinationTapped)))
        departureContainer.accessibilityLabel = "accessibility_choose_departure_button".localized()
        destinationContainer.accessibilityLabel = "accessibility_choose_destination_button".localized()
    }
    
    func setup(departure: String, destination: String, isOnLightBackground: Bool) {
        
        let destinationCountry = ADCountryPicker.countryForCode(code: destination)
        let isDestinationNLRules = destinationCountry?.getPassType() == .nlRules
        
        departureTitleLabel.font = Theme.fonts.caption1Montserrat
        departureLabel.font = Theme.fonts.caption1Montserrat
        
        destiantionLabel.font = Theme.fonts.caption1Montserrat
        destinationTitleLabel.font = Theme.fonts.caption1Montserrat
        riskLabel.font = Theme.fonts.footnoteMontserratBold
        riskLabel.textColor = isOnLightBackground ? Theme.colors.dark : Theme.colors.secondary
        
        departureContainer.backgroundColor = isDestinationNLRules ? UIColor.white.withAlphaComponent(0.7) : Theme.colors.inactiveCountry.withAlphaComponent(0.7)
        departureLabel.textColor = isDestinationNLRules ? Theme.colors.primary : Theme.colors.dark
        
        let departureCountry = ADCountryPicker.countryForCode(code: departure)
        let colourCode = departureCountry?.getColourCode()?.rawValue
        let colourName = Services.remoteConfigManager.getConfiguration().countryColors?.first(where: { it in
            it.isColourCode == true && it.color == colourCode
        })
        var riskLabelText = departure == "" ? "" : "\(colourName?.name() ?? "")"
        if !riskLabelText.isEmpty, let eu = departureCountry?.isEU {
            riskLabelText += " | \((eu ? "item_eu" : "item_not_eu").localized())"
        }
        riskLabel.text = riskLabelText
        departureLabel.text = !isDestinationNLRules ? "country_not_used".localized() : departure == "" ? "country_unselected".localized() : departureCountry?.name() ?? "country_unselected".localized()
        destiantionLabel.text = destination == "" ? "country_unselected".localized() :
            ADCountryPicker.countryForCode(code: destination)?.name() ?? ""
        
    }
    
    @objc func departureTapped() {
        onTappedDeparture?()
    }
    
    @objc func destinationTapped() {
        onTappedDestination?()
    }
    
}
