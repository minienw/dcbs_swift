//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

class CustomShadowView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    @IBInspectable var shadowOpacity: Float = 1
    @IBInspectable var shadowRadius: CGFloat = 1
    @IBInspectable var shadowOffsetX: CGFloat = 0
    @IBInspectable var shadowOffsetY: CGFloat = 0
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius = cornerRadius
    }
}
