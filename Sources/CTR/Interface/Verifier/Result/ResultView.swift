/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import UIKit
import SnapKit

class ResultView: TMCBaseView {

    @IBOutlet var vaccineView1: ResultVaccineView!
    
    @IBOutlet var deniedView: UIView!
    @IBOutlet var accessView: UIView!
    
    @IBOutlet var scrollView: HeaderScrollView!
    @IBOutlet var businessRuleFailures: UIStackView!
    @IBOutlet var deniedTitle: UILabel!
    @IBOutlet var deniedLabel: UILabel!
    @IBOutlet var dccNameLabel: UILabel!
    @IBOutlet var dateOfBirthLabel: UILabel!
    @IBOutlet var itemsStack: UIStackView!
    @IBOutlet var selectedCountryDeniedView: SelectedCountryView!
    @IBOutlet var selectedCountryView: SelectedCountryView!
    
    @IBOutlet var accessBackgroundView: UIView!
    @IBOutlet var accessLabel: UILabel!
    @IBOutlet var accessImageView: UIImageView!
    @IBOutlet var nextScanButton: CustomButton!
    
    var onTappedNextScan: (() -> Void)?
    var onTappedDeniedMessage: (() -> Void)?
    
    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    func getSelectedCountryView() -> SelectedCountryView {
        return deniedView.isHidden ? selectedCountryView : selectedCountryDeniedView
    }
    
    private func getSpacer(height: Int) -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.snp.makeConstraints { it in it.height.equalTo(height) }
        return spacer
    }
    
    func resetViews() {
        for view in businessRuleFailures.arrangedSubviews {
            businessRuleFailures.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for view in itemsStack.arrangedSubviews.filter({ it in
            it is ResultRecoveryView || it is ResultTestView || it is ResultItemView || it is ResultItemHeaderView
        }) {
            itemsStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func sharedSetup() {
        nextScanButton.titleLabel?.adjustsFontForContentSizeCategory = true
        nextScanButton.titleLabel?.font = Theme.fonts.bodyMontserratSemiBold
        nextScanButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextScanButton.titleLabel?.minimumScaleFactor = 0.5
        deniedTitle.adjustsFontForContentSizeCategory = true
        deniedTitle.font = Theme.fonts.title3Montserrat
        accessLabel.adjustsFontForContentSizeCategory = true
        accessLabel.font = Theme.fonts.title3Montserrat
    }
    
    func setupForVerified(dcc: DCCQR, isSpecimen: Bool, failingItems: [DCCFailableItem], shouldOverrideToGreen: Bool, brManager: BusinessRulesManager) {
        sharedSetup()
        deniedView.isHidden = true
        accessView.isHidden = false
        
        let showAsFailed = !failingItems.isEmpty && !shouldOverrideToGreen
        resetViews()
        if !shouldOverrideToGreen {
            for item in failingItems {
                let failureView = BusinessRuleFailureView()
                failureView.setup(failure: item, isGreenOverride: shouldOverrideToGreen)
                businessRuleFailures.addArrangedSubview(failureView)
            }
        }
        let isUndecided = failingItems.contains(where: { it in
            it.makesQRUndecided()
        })
        
        businessRuleFailures.addArrangedSubview(getSpacer(height: showAsFailed ? 24 : 36))
        
        let colour = isUndecided ? Theme.colors.tertiary : isSpecimen ? Theme.colors.greenGrey : showAsFailed ? Theme.colors.denied : Theme.colors.access
        subviews.first?.backgroundColor = colour
        accessBackgroundView.backgroundColor = colour
        scrollView.addHeaderColor(colour)
        accessLabel.textColor = isUndecided ? .black : .white
        accessLabel.text = (isUndecided ? "result_inconclusive_title" : showAsFailed ? "travel_not_met" : "travel_met").localized()
        accessImageView.image = UIImage(named: "access_inverted_qr")
        
        dccNameLabel.font = Theme.fonts.title1Montserrat
        dccNameLabel.adjustsFontForContentSizeCategory = true
        dccNameLabel.text = dcc.getName()
        dateOfBirthLabel.font = Theme.fonts.subheadBoldMontserrat
        dateOfBirthLabel.adjustsFontForContentSizeCategory = true
        if let dccData = dcc.dcc, let dob = dccData.getDateOfBirth() {
            dateOfBirthLabel.text = "item_date_of_birth_x".localized(params: dateFormat.string(from: dob))
        } else {
            dateOfBirthLabel.text = "item_date_of_birth_x".localized(params: dcc.dcc?.dateOfBirth ?? "item_unknown".localized())
        }
        setupVaccineViews(dcc: dcc, brManager: brManager)
        setupTests(dcc: dcc, brManager: brManager)
        setupRecoveries(dcc: dcc, brManager: brManager)
	}
    
    func updateCountryPicker(settings: UserSettings, relayout: Bool = true) {
        getSelectedCountryView().setup(departure: settings.lastDeparture, destination: settings.lastDestination, isOnLightBackground: accessBackgroundView.backgroundColor == Theme.colors.tertiary, scrollable: false)
        if relayout {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.updateCountryPicker(settings: settings, relayout: false)
            }
        }
    }
    
    func setupRecoveries(dcc: DCCQR, brManager: BusinessRulesManager) {
        guard let recoveries = dcc.dcc?.recoveries else { return }
        for recovery in recoveries {
            let header = ResultRecoveryView()
            header.setup(recovery: recovery, dateFormat: dateFormat, brManager: brManager)
            itemsStack.addArrangedSubview(header)
            
            if let date = recovery.getDateOfFirstPositiveTest() {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_first_date".localized(), value: dateFormat.string(from: date)))
            } else {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_first_date".localized(), value: recovery.dateOfFirstPositiveTest))
            }
            if let date = recovery.getDateValidFrom() {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_from".localized(), value: dateFormat.string(from: date)))
            } else {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_from".localized(), value: recovery.certificateValidFrom))
            }
            if let date = recovery.getDateValidTo() {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_to".localized(), value: dateFormat.string(from: date)))
            } else {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_to".localized(), value: recovery.certificateValidTo))
            }
            itemsStack.addArrangedSubview(getItem(key: "item_recovery_country".localized(), value: recovery.countryOfTest))
            itemsStack.addArrangedSubview(getItem(key: "item_certificate_issuer".localized(), value: recovery.certificateIssuer))
            itemsStack.addArrangedSubview(getItem(key: "item_identifier".localized(), value: recovery.certificateIdentifier))
        }
    }
    
    func setupTests(dcc: DCCQR, brManager: BusinessRulesManager) {
        guard let tests = dcc.dcc?.tests else { return }
        for test in tests {
            let header = ResultTestView()
            header.setup(test: test, dateFormat: dateFormat)
            itemsStack.addArrangedSubview(header)

            itemsStack.addArrangedSubview(getItem(key: "item_test_target".localized(), value: test.getTargetedDisease(manager: brManager) ?? test.targetedDisease))
            
            itemsStack.addArrangedSubview(getItem(key: "item_test_type".localized(), value: test.getTestType(manager: brManager) ?? test.typeOfTest))
            
            itemsStack.addArrangedSubview(getItem(key: "item_test_name".localized(), value: test.NAATestName ?? ""))
            itemsStack.addArrangedSubview(getItem(key: "item_test_manufacturer".localized(), value: test.getTestManufacturer(manager: Services.businessRulesManager) ?? test.RATTestNameAndManufac ?? ""))

            itemsStack.addArrangedSubview(getItem(key: "item_test_location".localized(), value: test.testingCentre ?? ""))
            itemsStack.addArrangedSubview(getItem(key: "item_test_country".localized(), value: test.countryOfTest))
            itemsStack.addArrangedSubview(getItem(key: "item_certificate_issuer".localized(), value: test.certificateIssuer))
            itemsStack.addArrangedSubview(getItem(key: "item_identifier".localized(), value: test.certificateIdentifier))
        }
    }
    
    func setupVaccineViews(dcc: DCCQR, brManager: BusinessRulesManager) {
        if let vaccines = dcc.dcc?.vaccines, let vaccine = vaccines.first {
            vaccineView1.setup(vaccine: vaccine, dateFormat: dateFormat, brManager: brManager)
            vaccineView1.isHidden = false
            addVaccineMeta(vaccine: vaccine, hasHeader: false, brManager: brManager)
        } else {
            vaccineView1.isHidden = true
        }
    }
    
    func addVaccineMeta(vaccine: DCCVaccine, hasHeader: Bool, brManager: BusinessRulesManager) {
        var targetString = ""
        if hasHeader {
            itemsStack.addArrangedSubview(getItemHeader(title: "item_dose_x".localized(params: vaccine.doseNumber)))
        }
        targetString += "\(vaccine.getTargetedDisease(manager: brManager) ?? vaccine.targetedDisease)"
        if targetString != "" {
            targetString += " | "
        }
        targetString += vaccine.getVaccine(manager: brManager) ?? vaccine.vaccine
        itemsStack.addArrangedSubview(getItem(key: "item_disease".localized(), value: targetString))
        itemsStack.addArrangedSubview(getItem(key: "item_country".localized(), value: vaccine.countryOfVaccination))
        itemsStack.addArrangedSubview(getItem(key: "item_test_manufacturer".localized(), value: vaccine.getMarketingHolder(manager: brManager) ?? vaccine.marketingAuthorizationHolder))
        itemsStack.addArrangedSubview(getItem(key: "item_certificate_issuer".localized(), value: vaccine.certificateIssuer))
        itemsStack.addArrangedSubview(getItem(key: "item_identifier".localized(), value: vaccine.certificateIdentifier))
    }
    
    func getItemHeader(title: String) -> ResultItemHeaderView {
        let view = ResultItemHeaderView()
        view.setup(title: title)
        return view
    }
    
    func getItem(key: String, value: String) -> ResultItemView {
        let view = ResultItemView()
        view.setup(key: key, label: value)
        return view
    }
    
	func setupForDenied() {
        deniedView.isHidden = false
        accessView.isHidden = true
        resetViews()
        sharedSetup()
        let deniedText = "verifier.result.denied.message".localized()
        let deniedTextUnderline = "verifier.result.denied.message.underline".localized()
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedString = NSMutableAttributedString(string: deniedText, attributes: [
            .foregroundColor: Theme.colors.dark,
            .font: Theme.fonts.title3,
            .paragraphStyle: style
        ])
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: Theme.colors.dark
        ], range: NSString(string: deniedText).range(of: deniedTextUnderline))
        deniedLabel.attributedText = attributedString
        subviews.first?.backgroundColor = Theme.colors.denied
        scrollView.addHeaderColor(Theme.colors.denied)
	}

	func revealIdentityView(_ onCompletion: (() -> Void)? = nil) {

        onCompletion?()
	}
    
    @IBAction func nextScanTapped(_ sender: Any) {
        onTappedNextScan?()
    }
    
    @IBAction func tappedDeniedMessage(_ sender: Any) {
        onTappedDeniedMessage?()
    }
    
}
