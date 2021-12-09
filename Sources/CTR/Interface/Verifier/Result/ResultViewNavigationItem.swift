//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class ResultViewNavigationItem: TMCBaseView {
    
    @IBOutlet var actionLabel: UILabel!
    @IBOutlet var timerContainer: CustomView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    var onTappedActionButton: (() -> Void)?
    
    func setup(onTapped: @escaping () -> Void) {
        isAccessibilityElement = false
        timerContainer.cornerRadius = 14
        timerContainer.isAccessibilityElement = false
        
        timerLabel?.accessibilityTraits = .updatesFrequently
        timerLabel?.font = Theme.fonts.subheadBoldMontserrat
        timerLabel?.adjustsFontForContentSizeCategory = true
        
        actionLabel?.font = Theme.fonts.footnoteMontserrat
        actionLabel?.adjustsFontForContentSizeCategory = true
        actionLabel?.accessibilityTraits = .button
        
        actionButton.isAccessibilityElement = false
        self.onTappedActionButton = onTapped
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        onTappedActionButton?()
    }
    
    func setTimer(time: Int, isPaused: Bool) {
        timerLabel.text = "\(time)"
        actionLabel.text = "\(isPaused ? "resume" : "pause")".localized()
        actionLabel.accessibilityLabel = actionLabel.text
        timerContainer.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timerContainer.layoutSubviews()
    }
}
