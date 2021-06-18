/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit
import SnapKit

class ResultView: TMCBaseView {

    @IBOutlet var deniedView: UIView!
    @IBOutlet var accessView: UIView!
    
    var onTappedNextScan: (() -> Void)?
    
	func setupForVerified() {
        deniedView.isHidden = true
        accessView.isHidden = false
		
	}

	func setupForDenied() {
        deniedView.isHidden = false
        accessView.isHidden = true
	}

	func revealIdentityView(_ onCompletion: (() -> Void)? = nil) {

        
        onCompletion?()
	}
    
    @IBAction func nextScanTapped(_ sender: Any) {
        onTappedNextScan?()
    }
    
}
