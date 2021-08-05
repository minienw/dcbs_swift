//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ColorCodeView: TMCBaseView {
    
    @IBOutlet var label: UILabel!
    
    var onItemTapped: (() -> Void)?
    
    func setup(color: CountryRisk, onTapped: @escaping () -> Void) {
        self.label.font = Theme.fonts.body
        self.label.text = color.name() ?? ""
        self.onItemTapped = onTapped
    }
    
    @IBAction func itemTapped(_ sender: Any) {
        onItemTapped?()
    }
}
