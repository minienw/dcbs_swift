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

class VerifierStartNavigationController: UINavigationController {
    
    var timer: Timer?
    
    var proofManager: ProofManager?
    
    var banner: OutdatedTrustView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proofManager = ProofManager()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.checkTrustLists()
        })
        
    }
    
    private func checkTrustLists() {
        if proofManager?.shouldShowOutdatedKeysBanner() != false {
            addTrustListBanner()
        }
    }
    
    private func addTrustListBanner() {
        guard banner == nil else { return }
        banner = OutdatedTrustView()
        if let banner = banner {
            banner.alpha = 0
            view.addSubview(banner)
            banner.setLoading(loading: false)
            banner.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(67)
                make.height.equalTo(110)
                make.leading.trailing.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2) {
                banner.alpha = 1
            }
            banner.onPressed = { [weak self] in
                banner.setLoading(loading: true)
                self?.proofManager?.fetchIssuerPublicKeys(onCompletion: {
                    self?.removeTrustListBanner()
                }, onError: { _ in
                    OperationQueue.main.addOperation {
                        banner.setLoading(loading: false)
                    }
                })
            }
        }

    }
    
    private func removeTrustListBanner() {
        OperationQueue.main.addOperation {
            UIView.animate(withDuration: 0.2) {
                self.banner?.alpha = 0
            } completion: { _ in
                self.banner?.removeFromSuperview()
                self.banner = nil
            }
        }
    }
}
