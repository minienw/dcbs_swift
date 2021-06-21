//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ResultItemHeaderView: TMCBaseView {
    
    @IBOutlet var label: UILabel!
    
    func setup(title: String) {
        label.text = title
    }
    
}
