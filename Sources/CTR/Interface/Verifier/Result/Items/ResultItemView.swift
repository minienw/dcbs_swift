//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ResultItemView: TMCBaseView {
    
    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    func setup(key: String, label: String) {
        keyLabel.font = Theme.fonts.subheadMedium
        valueLabel.font = Theme.fonts.subheadMontserrat
        keyLabel.text = key
        valueLabel.text = label
    }
    
}
