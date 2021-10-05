//
//  KeyboardManager.swift
//  How to Talk
//
//  Created by Guus Mulder  | The Mobile Company on 16/02/2021.
//

import Foundation
import UIKit

protocol KeyboardManagerDelegate: AnyObject {
    func keyboardAppeared()
    func keyboardDissapeared()
}

class KeyboardManager {
    
    let updateConstraints: [NSLayoutConstraint]
    let onView: UIView
    let returnToHeight: CGFloat
    
    var shouldAppendReturnToHeight: Bool
    
    weak var delegate: KeyboardManagerDelegate?
    
    /// Given constraints will be moved up when keyboard shows and back down when it's removed
    init(updateConstraints: [NSLayoutConstraint], onView: UIView, returnToHeight: CGFloat = 0, shouldAppendReturnToHeight: Bool = true) {
        self.shouldAppendReturnToHeight = shouldAppendReturnToHeight
        self.updateConstraints = updateConstraints
        self.onView = onView
        self.returnToHeight = returnToHeight
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        for constraint in updateConstraints {
            constraint.constant = keyboardHeight + (shouldAppendReturnToHeight ? returnToHeight : 5)
        }
        UIView.animate(withDuration: 0.2) {
            self.onView.layoutIfNeeded()
            self.delegate?.keyboardAppeared()
        }
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        for constraint in updateConstraints {
            constraint.constant = returnToHeight
        }
        UIView.animate(withDuration: 0.2) {
            self.onView.layoutIfNeeded()
            self.delegate?.keyboardDissapeared()
        }
    }
    
}
