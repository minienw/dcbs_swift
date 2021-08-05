//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit
import SnapKit

class HeaderScrollView: UIScrollView {
    private var headerColorView: UIView?
    private var bottomColorView: UIView?
    private var headerHeightConstraint: Constraint?
    private var bottomHeightConstraint: Constraint?

    func resetHeaderColorView() {
        headerColorView?.removeFromSuperview()
        headerColorView = nil
    }
    func addHeaderColor(_ color: UIColor) {
        resetHeaderColorView()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top)
            make.left.right.equalToSuperview()
            headerHeightConstraint = make.height.equalTo(0).constraint
        }
        view.backgroundColor = color
        headerColorView = view
        
        delegate = self
    }
    
    func addBottomColor(_ color: UIColor) {
        guard bottomColorView == nil else { return }
        let view = UIView()
        addSubview(view)
        
        view.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom)
            make.left.right.equalToSuperview()
            bottomHeightConstraint = make.height.equalTo(0).constraint
        }
        
        view.backgroundColor = color
        bottomColorView = view
        
        delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
        resignFirstResponder()
    }
    
}

extension HeaderScrollView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let headerHeightConstraint = headerHeightConstraint {
            headerHeightConstraint.update(offset: 0 - scrollView.contentOffset.y)
        }
        if let bottomHeightConstraint = bottomHeightConstraint {
            bottomHeightConstraint.update(offset: 0 + scrollView.contentOffset.y)
        }
    }
    
}
