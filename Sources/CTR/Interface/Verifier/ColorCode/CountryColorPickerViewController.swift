//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import UIKit

protocol CountryColorPickerDelegate: AnyObject {
    func didChooseItem(area: CountryRisk)
}
class CountryColorPickerViewController: BaseViewController {
    
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var countriesButton: UIButton!
    @IBOutlet var coloursButton: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var countryPicker: ADCountryPicker?
    var colourPicker: ColorPickerViewController?
    var coordinator: OpenUrlProtocol?
    weak var delegate: CountryColorPickerDelegate?
    let remoteConfigManager = Services.remoteConfigManager
    var keyboardManager: KeyboardManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "country_departure_title".localized()
        setButtonActive(active: true, button: countriesButton)
        setButtonActive(active: false, button: coloursButton)
        countriesButton.titleLabel?.font = Theme.fonts.title3Montserrat
        coloursButton.titleLabel?.font = Theme.fonts.title3Montserrat
        
        view.layoutSubviews()
        addCountriesPicker()
        addColourPicker()
        keyboardManager = KeyboardManager(updateConstraints: [bottomConstraint], onView: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        remoteConfigManager.setDelegate(delegate: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        remoteConfigManager.setDelegate(delegate: nil)
    }
    
    @IBAction func countriesButtonTapped(_ sender: Any) {
        setButtonActive(active: false, button: coloursButton)
        setButtonActive(active: true, button: countriesButton)
        self.countryPicker?.view.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.countryPicker?.view.alpha = 1
            self.colourPicker?.view.alpha = 0
        } completion: { _ in
            self.colourPicker?.view.isHidden = true
        }

    }
    
    @IBAction func coloursButtonTapped(_ sender: Any) {
        setButtonActive(active: true, button: coloursButton)
        setButtonActive(active: false, button: countriesButton)
        self.colourPicker?.view.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.countryPicker?.view.alpha = 0
            self.colourPicker?.view.alpha = 1
        } completion: { _ in
            self.countryPicker?.view.isHidden = true
        }
        view.endEditing(true)
    }
    
    func setButtonActive(active: Bool, button: UIButton) {
        button.alpha = active ? 1 : 0.3
    }
    
    private func addCountriesPicker() {
        let picker = ADCountryPicker()
        picker.selectingMode = .departure
        picker.pickerTitle = ""
        picker.delegate = self
        addChild(picker)
        picker.view.frame = CGRect(x: 0, y: 0, width: mainContainer.frame.width, height: mainContainer.frame.height)
        mainContainer.addSubview(picker.view)
        picker.didMove(toParent: self)
        countryPicker = picker
        picker.view.alpha = 1
    }
    
    private func addColourPicker() {
        let picker: ColorPickerViewController = getVC(in: "ColorPicker")
        picker.onSelectedItem = { [weak self] result in
            self?.delegate?.didChooseItem(area: result)
        }
        picker.coordinator = coordinator
        
        addChild(picker)
        picker.view.frame = CGRect(x: 0, y: 0, width: mainContainer.frame.width, height: mainContainer.frame.height)
        mainContainer.addSubview(picker.view)
        picker.didMove(toParent: self)
        picker.view.alpha = 0
        colourPicker = picker
    }
}

extension CountryColorPickerViewController: ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelect: CountryRisk) {
        delegate?.didChooseItem(area: didSelect)
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension CountryColorPickerViewController: RemoteConfigManagerDelegate {
    func configWasUpdated() {
        OperationQueue.main.addOperation {
            self.countryPicker?.update()
            self.colourPicker?.update()
        }
    }
}
