//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

class TrustListUpdateScheduler {
    
    static let instance = TrustListUpdateScheduler()
    
    let proofManager: ProofManager
    
    var timer: Timer?
    
    init() {
        proofManager = ProofManager()
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
            if self.proofManager.shouldUpdateKeys() {
                self.proofManager.fetchIssuerPublicKeys(onCompletion: nil, onError: nil)
            }
        })
    }
    
}
