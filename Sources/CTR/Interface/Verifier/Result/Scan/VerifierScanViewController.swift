/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit

class VerifierScanViewController: ScanViewController {

	private let viewModel: VerifierScanViewModel
    
    let userSettings = UserSettings()
    
    var currentSelectingCountryMode: SelectingCountryMode?

	init(viewModel: VerifierScanViewModel) {

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

		viewModel.$title.binding = { [weak self] in self?.title = $0 }

		viewModel.$message.binding = { [weak self] in self?.sceneView.message = $0 }

		viewModel.$startScanning.binding = { [weak self] in
			if $0, self?.captureSession?.isRunning == false {
				self?.captureSession.startRunning()
			}
		}
		viewModel.$torchLabels.binding = { [weak self] in
			guard let strongSelf = self else { return }
            strongSelf.addTorchButton(
                action: #selector(strongSelf.toggleTorch),
                enableLabel: $0.first,
                disableLabel: $0.last
            )
		}

		viewModel.$showPermissionWarning.binding = { [weak self] in
			if $0 {
				self?.showPermissionError()
			}
		}
        updateCountryPicker()
        sceneView.selectedCountryView.onTappedDeparture = { [weak self] in
            self?.openCountryColorCodePicker()
        }
        
        sceneView.selectedCountryView.onTappedDestination = { [weak self] in
            self?.openCountryPicker()
        }
		
		addCloseButton(
			action: #selector(closeButtonTapped),
			backgroundColor: .clear,
			tintColor: .white
		)
		// Only show an arrow as back button
		styleBackButton(buttonText: "")
        
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTranslucentNavigationBar()
        (navigationController as? VerifierStartNavigationController)?.moveTrustListBannerDown()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        (navigationController as? VerifierStartNavigationController)?.moveTrustListBannerUp()
    }
    
    func updateCountryPicker() {
        sceneView.selectedCountryView.setup(departure: userSettings.lastDeparture, destination: userSettings.lastDestination)
    }
    
    func openCountryColorCodePicker() {
        self.currentSelectingCountryMode = .departure
        let picker: CountryColorPickerViewController = getVC(in: "CountryColorPicker")
        picker.onSelectedItem = { [weak self] result in
            self?.onPickedCountryColor(code: result)
        }
        picker.coordinator = viewModel.coordinator
        resetTranslucentNavigationBar()
        navigationController?.pushViewController(picker, animated: true)
    }
    
    private func onPickedCountryColor(code: String) {
        userSettings.lastDeparture = code
        updateCountryPicker()
        configureTranslucentNavigationBar()
    }
    
    func openCountryPicker() {
        self.currentSelectingCountryMode = .destination
        let picker = ADCountryPicker()
        picker.selectingMode = .destination
        picker.showFlags = false
        picker.showCallingCodes = false
        picker.pickerTitle = "country_destination_title".localized()
        picker.delegate = self
        resetTranslucentNavigationBar()
        navigationController?.pushViewController(picker, animated: true)
    }

	override func found(code: String) {

		viewModel.parseQRMessage(code)
	}

	/// User tapped on the button
	@objc func closeButtonTapped() {

		viewModel.dismiss()
	}

	/// Show alert
	func showPermissionError() {

		let alertController = UIAlertController(
			title: .verifierScanPermissionTitle,
			message: .verifierScanPermissionMessage,
			preferredStyle: .alert
		)
		alertController.addAction(
			UIAlertAction(
				title: .verifierScanPermissionSettings,
				style: .default,
				handler: { [weak self] _ in
					self?.viewModel.gotoSettings()
				}
			)
		)
		alertController.addAction(
			UIAlertAction(
				title: .cancel,
				style: .cancel,
				handler: nil
			)
		)
		present(alertController, animated: true, completion: nil)
	}
}

extension VerifierScanViewController: ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        if currentSelectingCountryMode == .departure {
            userSettings.lastDeparture = code
        } else if currentSelectingCountryMode == .destination {
            userSettings.lastDestination = code
        }
        updateCountryPicker()
        configureTranslucentNavigationBar()
        picker.navigationController?.popViewController(animated: true)
    }
}