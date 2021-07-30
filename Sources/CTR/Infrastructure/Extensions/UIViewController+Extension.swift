//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

extension UIViewController {
	
	/// Configure translucent navigation bar. By default, navigation bar has an opaque background
	func configureTranslucentNavigationBar() {
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.navigationBar.backgroundColor = .clear
		navigationController?.navigationBar.barTintColor = .clear
	}
    
    func resetTranslucentNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = Theme.colors.viewControllerBackground
        navigationController?.navigationBar.barTintColor = Theme.colors.viewControllerBackground
    }
    
    func getVC<T: UIViewController>(id: String? = nil, in storyboardId: String) -> T {
        let sb = UIStoryboard(name: storyboardId, bundle: nil)
        guard let id = id else {
            return sb.instantiateInitialViewController() as! T
        }
        return sb.instantiateViewController(withIdentifier: id) as! T
    }
}
