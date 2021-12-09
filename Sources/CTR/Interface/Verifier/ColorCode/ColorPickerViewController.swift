//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ColorPickerViewController: BaseViewController {
    
    @IBOutlet var viewColorCodesLabel: UILabel!
    @IBOutlet var viewColorCodesButton: UIButton!
    
    @IBOutlet var colourStack: UIStackView!
    
    var onSelectedItem: ((CountryRisk) -> Void)?
    var coordinator: OpenUrlProtocol?
    
    let configManager = Services.remoteConfigManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "country_departure_title".localized()
        viewColorCodesLabel.font = Theme.fonts.title3Montserrat
        viewColorCodesButton.titleLabel?.font = Theme.fonts.bodyMontserratSemiBold
        viewColorCodesButton.titleLabel?.numberOfLines = 0
        viewColorCodesButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        update()
    }
    
    func update() {
        let items = configManager.getConfiguration().countryColors?.filter({ it in
            it.isColourCode == true
        })
        for view in colourStack.arrangedSubviews {
            colourStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for item in items ?? [] {
            let view = ColorCodeView()
            view.setup(color: item) { [weak self] in
                self?.selectedCode(area: item)
            }
            colourStack.addArrangedSubview(view)
            view.snp.makeConstraints { it in
                it.height.greaterThanOrEqualTo(52)
            }
        }
    }
    
    private func selectedCode(area: CountryRisk) {
        self.onSelectedItem?(area)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewColorCodesButtonTapped(_ sender: Any) {
        if let url = URL(string: "url.view_color_codes".localized()) {
            coordinator?.openUrl(url, inApp: true)
        }
    }
    
}
