//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class CountryColorPickerViewController: BaseViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var viewColorCodesLabel: UILabel!
    @IBOutlet var viewColorCodesButton: UIButton!
    
    @IBOutlet var greenView: ColorCodeView!
    @IBOutlet var yellowView: ColorCodeView!
    @IBOutlet var orangeView: ColorCodeView!
    @IBOutlet var redView: ColorCodeView!
    
    var onSelectedItem: ((String) -> Void)?
    var coordinator: OpenUrlProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "country_departure_title".localized()
        titleLabel.font = Theme.fonts.title3Montserrat
        viewColorCodesLabel.font = Theme.fonts.title3Montserrat
        viewColorCodesButton.titleLabel?.font = Theme.fonts.bodyMontserratSemiBold
        
        greenView.setup(color: .green, onTapped: { [weak self] in
            self?.selectedCode(code: .green)
        })
        yellowView.setup(color: .yellow, onTapped: { [weak self] in
            self?.selectedCode(code: .yellow)
        })
        orangeView.setup(color: .orange, onTapped: { [weak self] in
            self?.selectedCode(code: .orange)
        })
        redView.setup(color: .red, onTapped: { [weak self] in
            self?.selectedCode(code: .red)
        })
    }
    
    private func selectedCode(code: CountryColorCode) {
        self.onSelectedItem?(code.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewColorCodesButtonTapped(_ sender: Any) {
        if let url = URL(string: "url.view_color_codes".localized()) {
            coordinator?.openUrl(url, inApp: true)
        }
    }
    
}
