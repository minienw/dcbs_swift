//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class OutdatedTrustView: TMCBaseView {
    
    @IBOutlet weak var updateButton: CustomButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var onPressed: (() -> Void)?
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        onPressed?()
    }
    
    func setLoading(loading: Bool) {
        spinner.isHidden = !loading
        updateButton.setTitle(loading ? "" : Localization.string(for: "certificates_outdated_button"), for: .normal)
    }
    
}
