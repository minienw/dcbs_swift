/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

class VerifierStartViewController: BaseViewController {

	private let viewModel: VerifierStartViewModel

	let sceneView = HeaderTitleMessageButtonView()

	init(viewModel: VerifierStartViewModel) {

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

        AccessibilityUtility.requestFocus(to: self.navigationItem.titleView)
        TrustListUpdateScheduler.instance.start()
		viewModel.$title.binding = { [weak self] in self?.title = $0 }
		viewModel.$header.binding = { [weak self] in self?.sceneView.title = $0 }
		viewModel.$message.binding = { [weak self] in self?.sceneView.message = $0 }
		viewModel.$primaryButtonTitle.binding = { [weak self] in self?.sceneView.primaryTitle = $0 }

		sceneView.primaryButtonTappedCommand = { [weak self] in

			self?.viewModel.primaryButtonTapped()
		}

        view.backgroundColor = Theme.colors.viewControllerBackground
        let barItem = UIBarButtonItem(image: .about, style: .plain, target: self, action: #selector(aboutTapped))
        navigationItem.setRightBarButton(barItem, animated: false)

		sceneView.contentTextView.linkTouched { [weak self] _ in
            self?.viewModel.linkTapped()
		}

		sceneView.headerImage = .scanStart
		// Only show an arrow as back button
		styleBackButton(buttonText: "")
    }

	// MARK: User interaction

	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
		layoutForOrientation()
	}

	// Rotation

	override func willTransition(
		to newCollection: UITraitCollection,
		with coordinator: UIViewControllerTransitionCoordinator) {

		coordinator.animate { [weak self] _ in
			self?.layoutForOrientation()
			self?.sceneView.setNeedsLayout()
		}
	}

	/// Layout for different orientations
	func layoutForOrientation() {

		if traitCollection.verticalSizeClass == .compact {
			sceneView.hideImage()
		} else {
			sceneView.showImage()
		}
	}
    
    @objc private func aboutTapped() {
        viewModel.aboutTappd()
    }
}
