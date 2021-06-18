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
    
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var dccNameLabel: UILabel!
    @IBOutlet var dateOfBirthLabel: UILabel!
    @IBOutlet var vaccinesStack: UIStackView!
    @IBOutlet var itemsStack: UIStackView!
    
    var onTappedNextScan: (() -> Void)?
    
    func setupForVerified(dcc: DCCQR) {
        deniedView.isHidden = true
        accessView.isHidden = false
		
        dccNameLabel.text = dcc.getName()
        dateOfBirthLabel.text = dcc.getBirthDate()
        if let issuer = dcc.getIssuer {
            itemsStack.addArrangedSubview(getItem(key: "Issuer", value: issuer.rawValue))
        }
	}

    func getItem(key: String, value: String) -> ResultItemView {
        let view = ResultItemView()
        view.setup(key: key, label: value)
        return view
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
