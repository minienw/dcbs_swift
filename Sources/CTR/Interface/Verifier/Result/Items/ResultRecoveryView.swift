//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ResultRecoveryView: TMCBaseView {
    
    @IBOutlet var label: UILabel!
    
    func setup(disease: TargetedDisease) {
        label.font = Theme.fonts.subheadBoldMontserrat
        label.text = "\(disease.displayName)\n\("item_recovery_header".localized())"
    }
    
}