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
    
    override func initLayout() {
        super.initLayout()
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemTapped)))
    }
    
    func setup(color: CountryRisk, onTapped: @escaping () -> Void) {
        self.label.font = Theme.fonts.body
        self.label.text = color.name() ?? ""
        self.onItemTapped = onTapped
        view?.subviews.first?.accessibilityTraits = [.button, .allowsDirectInteraction]
        view?.subviews.first?.accessibilityLabel = color.name() ?? ""
    }
    
    @objc func itemTapped() {
        onItemTapped?()
    }
}
