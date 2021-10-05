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
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .clear
            appearance.titleTextAttributes = navigationController?.navigationBar.titleTextAttributes ?? [:]
            appearance.configureWithTransparentBackground()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.navigationBar.backgroundColor = .clear
		navigationController?.navigationBar.barTintColor = .clear
        
	}
    
    func resetTranslucentNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = Theme.colors.viewControllerBackground
            appearance.titleTextAttributes = navigationController?.navigationBar.titleTextAttributes ?? [:]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
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
