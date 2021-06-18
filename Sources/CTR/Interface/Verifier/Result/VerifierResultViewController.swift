/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

class VerifierResultViewController: BaseViewController, Logging {

	private let viewModel: VerifierResultViewModel

	let sceneView = ResultView()

	init(viewModel: VerifierResultViewModel) {

		self.viewModel = viewModel

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {

		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View lifecycle
	override func loadView() {

		view = sceneView
	}

	override func viewDidLoad() {

		super.viewDidLoad()
		
		configureTranslucentNavigationBar()

        sceneView.onTappedNextScan = { [weak self] in
            self?.viewModel.scanAgain()
        }
        if let dcc = viewModel.cryptoResults.attributes {
            self.sceneView.setupForDenied()
            if dcc.isVerified {
                self.sceneView.setupForVerified(dcc: dcc)
            } else if dcc.isSpecimen {
                self.sceneView.setupForVerified(dcc: dcc)
            } else {
                self.sceneView.setupForDenied()
            }
        } else {
            self.sceneView.setupForDenied()
        }

		viewModel.$hideForCapture.binding = { [weak self] in

            #if DEBUG
            self?.logDebug("Skipping hiding of result because in DEBUG mode")
            #else
            self?.sceneView.isHidden = $0
            #endif
		}
		

		addCloseButton(action: #selector(closeButtonTapped))
	}

	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
		// Make the navbar the same color as the background.
		navigationController?.navigationBar.backgroundColor = .clear
	}

	/// User tapped on the button
	@objc func closeButtonTapped() {

		viewModel.dismiss()
	}

	// MARK: User interaction

	/// User tapped on the link
	@objc func linkTapped() {

		viewModel.linkTapped()
	}

}
