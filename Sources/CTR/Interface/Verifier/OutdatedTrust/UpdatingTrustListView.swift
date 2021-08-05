//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class UpdatingTrustListView: TMCBaseView {
    
    @IBOutlet var titleLabel: UILabel!
    
    override func setupLayout() {
        super.setupLayout()
        alpha = 0
        titleLabel.font = Theme.fonts.footnote
    }
    
}
