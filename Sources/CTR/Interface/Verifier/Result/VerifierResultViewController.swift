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
        viewModel.$autoCloseTicks.binding = { [weak self] in
            self?.setNavigationTimer(time: $0, isPaused: false)
        }

		viewModel.$hideForCapture.binding = { [weak self] in

            #if DEBUG
            self?.logDebug("Skipping hiding of result because in DEBUG mode")
            #else
            self?.sceneView.isHidden = $0
            #endif
		}
		
		addCloseButton(action: #selector(closeButtonTapped))
        setNavigationTimer(time: 0, isPaused: false)
	}

	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
		// Make the navbar the same color as the background.
		navigationController?.navigationBar.backgroundColor = .clear
	}
    
    func setNavigationTimer(time: Int, isPaused: Bool) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 95, height: 28))
        
        let circle = CustomView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        circle.cornerRadius = 14
        circle.backgroundColor = Theme.colors.primary
        let timeLabel = UILabel(frame: circle.frame)
        timeLabel.text = "\(VerifierResultViewModel.timeUntilAutoClose - time)"
        timeLabel.font = Theme.fonts.subheadBold
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        circle.addSubview(timeLabel)
        view.addSubview(circle)
        
        let playPauseLabel = UILabel(frame: CGRect(x: 35, y: 0, width: 60, height: 28))
        playPauseLabel.text = "\(isPaused ? "resume" : "pause")".localized()
        playPauseLabel.textColor = Theme.colors.primary
        playPauseLabel.font = Theme.fonts.footnoteMontserrat
        view.addSubview(playPauseLabel)
        
        let button = UIButton(frame: view.frame)
        button.addTarget(self, action: #selector(didTapPauseTimer), for: .touchUpInside)
        view.addSubview(button)
        
        navigationItem.setRightBarButton(UIBarButtonItem(customView: view), animated: false)
    }
    
    @objc func didTapPauseTimer() {
        if viewModel.isAutoCloseTimerActive() {
            viewModel.stopAutoCloseTimer()
        } else {
            viewModel.startAutoCloseTimer()
        }
        setNavigationTimer(time: viewModel.autoCloseTicks, isPaused: !viewModel.isAutoCloseTimerActive())
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
