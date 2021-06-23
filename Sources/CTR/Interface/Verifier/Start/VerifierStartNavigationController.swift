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
    
    var trustListShouldMoveDown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proofManager = ProofManager()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.checkTrustLists()
        })
        
    }
    
    func moveTrustListBannerUp() {
        trustListShouldMoveDown = false
        banner?.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(67)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func moveTrustListBannerDown() {
        trustListShouldMoveDown = true
        banner?.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(177)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func checkTrustLists() {
        if proofManager?.shouldShowOutdatedKeysBanner() != false {
            addTrustListBanner()
        } else {
            removeTrustListBanner()
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
                make.top.equalToSuperview().offset(trustListShouldMoveDown ? 177 : 67)
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
        guard let banner = banner else { return }
        OperationQueue.main.addOperation {
            UIView.animate(withDuration: 0.2) {
                banner.alpha = 0
            } completion: { _ in
                banner.removeFromSuperview()
                self.banner = nil
            }
        }
    }
}
