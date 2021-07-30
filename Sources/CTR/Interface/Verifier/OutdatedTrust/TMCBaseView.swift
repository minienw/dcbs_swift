//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

/// 🤖 The base for all the UIView classes. Contains all the required functions.
@IBDesignable
class TMCBaseView: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewWithXib()
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViewWithXib()
        initLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    /**
     Called upon when creating the view. Use for setting up layout objects like color, text etc.
     
     ## Example ##
     ```
     func initLayout() {
        setupLabels()
        setupButtons()
        setupTextFields()
     }
     ```
    */
    func initLayout() {
        
    }
    
    /**
     Called upon to create the layout for the required objects. Use this when you need to set objects after the view properties are available
     
     ## Example ##
     ```
     func setupLayout() {
        setupNewView()
        setupNewScrollView()
        setupNewButton()
     }
     ```
     */
    func setupLayout() {
        
    }
    
}

// MARK: - Private functions
extension TMCBaseView {
    
    /// Setup the view based on the xib that matches the file name.
    func setupViewWithXib() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        addSubview(view)
    }
    
    /// Get the correct view from the xib.
    ///
    /// - Returns: The view loaded from the matching XIB file.
    func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }
    
}
