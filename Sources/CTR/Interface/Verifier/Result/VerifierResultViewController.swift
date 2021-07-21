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
    
    var currentSelectingCountryMode: SelectingCountryMode?
    
    let userSettings = UserSettings()
    
    let remoteConfig = Services.remoteConfigManager

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
        setupResultView()
        
        self.sceneView.onTappedDeniedMessage = { [weak self] in
            self?.viewModel.navigateToDeniedHelp()
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
        sceneView.updateCountryPicker(settings: userSettings)
        
        sceneView.selectedCountryView.onTappedDeparture = { [weak self] in
            self?.openCountryColorCodePicker()
        }
        sceneView.selectedCountryDeniedView.onTappedDeparture = { [weak self] in
            self?.openCountryColorCodePicker()
        }
        sceneView.selectedCountryView.onTappedDestination = { [weak self] in
            self?.openCountryPicker()
        }
        sceneView.selectedCountryDeniedView.onTappedDestination = { [weak self] in
            self?.openCountryPicker()
        }
        
		addCloseButton(action: #selector(closeButtonTapped))
        setNavigationTimer(time: 0, isPaused: false)
	}

	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
		// Make the navbar the same color as the background.
		navigationController?.navigationBar.backgroundColor = .clear
        configureTranslucentNavigationBar()
	}
    
    private func setupResultView() {
        
        let from = ADCountryPicker.countryForCode(code: userSettings.lastDeparture) ?? .unselected
        let to = ADCountryPicker.countryForCode(code: userSettings.lastDestination) ?? .unselected
        if let dcc = viewModel.cryptoResults.attributes {
            if dcc.isVerified {
                let failingItems = dcc.processBusinessRules(from: from, to: to, businessRuleManager: Services.businessRulesManager)
                self.sceneView.setupForVerified(dcc: dcc, isSpecimen: false, failingItems: failingItems)
            } else {
                self.sceneView.setupForDenied()
            }
        } else {
            self.sceneView.setupForDenied()
        }
        
    }
    
    func setNavigationTimer(time: Int, isPaused: Bool) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 95, height: 28))
        
        let circle = CustomView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        circle.cornerRadius = 14
        circle.backgroundColor = Theme.colors.primary
        let timeLabel = UILabel(frame: circle.frame)
        timeLabel.text = "\(VerifierResultViewModel.timeUntilAutoClose - time)"
        timeLabel.font = Theme.fonts.subheadBoldMontserrat
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.5
        circle.addSubview(timeLabel)
        view.addSubview(circle)
        
        let playPauseLabel = UILabel(frame: CGRect(x: 35, y: 0, width: 60, height: 28))
        playPauseLabel.text = "\(isPaused ? "resume" : "pause")".localized()
        playPauseLabel.textColor = Theme.colors.primary
        playPauseLabel.font = Theme.fonts.footnoteMontserrat
        playPauseLabel.minimumScaleFactor = 0.5
        playPauseLabel.adjustsFontSizeToFitWidth = true
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
        /// Do nothing
	}
    
    func openCountryPicker() {
        self.currentSelectingCountryMode = .destination
        let picker = ADCountryPicker()
        picker.selectingMode = .destination
        picker.pickerTitle = "country_destination_title".localized()
        picker.delegate = self
        resetTranslucentNavigationBar()
        navigationController?.pushViewController(picker, animated: true)
    }

    func openCountryColorCodePicker() {
        self.currentSelectingCountryMode = .departure
        let picker: CountryColorPickerViewController = getVC(in: "CountryColorPicker")
        picker.delegate = self
        picker.coordinator = viewModel.coordinator
        resetTranslucentNavigationBar()
        navigationController?.pushViewController(picker, animated: true)
    }
    
    private func onPickedCountryColor(area: CountryRisk) {
        userSettings.lastDeparture = area.code ?? ""
        configureTranslucentNavigationBar()
        setupResultView()
        sceneView.updateCountryPicker(settings: userSettings)
    }
    
}

extension VerifierResultViewController: ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelect: CountryRisk) {
        userSettings.lastDestination = didSelect.code ?? ""
        configureTranslucentNavigationBar()
        picker.navigationController?.popViewController(animated: true)
        setupResultView()
        sceneView.updateCountryPicker(settings: userSettings)
    }
}

extension VerifierResultViewController: CountryColorPickerDelegate {
    func didChooseItem(area: CountryRisk) {
        onPickedCountryColor(area: area)
    }
}
