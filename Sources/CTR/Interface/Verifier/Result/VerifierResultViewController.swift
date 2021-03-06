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
    
    let businessRulesManager = Services.businessRulesManager
    
    var navigationView: ResultViewNavigationItem?

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
            let timeLeft = self?.timeLeft(time: $0) ?? 0
            if timeLeft % 10 == 0 && timeLeft != 0 {
                UIAccessibility.post(notification: .announcement, argument: "accessibility_result_timer_x_seconds".localized(params: timeLeft))
            }
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
        createTimer()
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
                self.sceneView.setupForVerified(dcc: dcc, isSpecimen: false, failingItems: failingItems, shouldOverrideToGreen: dcc.shouldShowGreenOverride(from: from, to: to), brManager: businessRulesManager)
            } else {
                self.sceneView.setupForDenied()
            }
        } else {
            self.sceneView.setupForDenied()
        }
        
    }
    
    func createTimer() {
        let navigationView = ResultViewNavigationItem()
        navigationView.setup { [weak self] in
            self?.didTapPauseTimer()
        }
        navigationView.snp.makeConstraints { make in
            make.width.equalTo(250)
        }
        
        let item = UIBarButtonItem(customView: navigationView)
        item.isAccessibilityElement = false
        navigationItem.setRightBarButton(item, animated: false)
        self.navigationView = navigationView
    }
    
    func timeLeft(time: Int) -> Int {
        return VerifierResultViewModel.timeUntilAutoClose - time
    }
    
    func setNavigationTimer(time: Int, isPaused: Bool) {
        navigationView?.setTimer(time: timeLeft(time: time), isPaused: isPaused)
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
        /// departure not available when destination is not nl
        let destinationCountry = ADCountryPicker.countryForCode(code: userSettings.lastDestination)
        let isDestinationNLRules = destinationCountry?.getPassType() == .nlRules
        if !isDestinationNLRules {
            return
        }
        
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
