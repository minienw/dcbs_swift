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
    @IBOutlet var vaccineView2: ResultVaccineView!
    
    @IBOutlet var deniedView: UIView!
    @IBOutlet var accessView: UIView!
    
    @IBOutlet var scrollView: HeaderScrollView!
    @IBOutlet var businessRuleFailures: UIStackView!
    @IBOutlet var deniedLabel: UILabel!
    @IBOutlet var dccNameLabel: UILabel!
    @IBOutlet var dateOfBirthLabel: UILabel!
    @IBOutlet var vaccinesStack: UIStackView!
    @IBOutlet var itemsStack: UIStackView!
    @IBOutlet var selectedCountryDeniedView: SelectedCountryView!
    @IBOutlet var selectedCountryView: SelectedCountryView!
    
    @IBOutlet var accessBackgroundView: UIView!
    @IBOutlet var accessLabel: UILabel!
    @IBOutlet var accessImageView: UIImageView!
    
    var onTappedNextScan: (() -> Void)?
    var onTappedDeniedMessage: (() -> Void)?
    
    var dateFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
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
            it is ResultRecoveryView || it is ResultTestView || it is ResultVaccineView || it is ResultItemView || it is ResultItemHeaderView
        }) {
            itemsStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func setupForVerified(dcc: DCCQR, isSpecimen: Bool, failingItems: [DCCFailableItem]) {
        deniedView.isHidden = true
        accessView.isHidden = false
        
        let showAsFailed = !failingItems.isEmpty
        resetViews()
        for item in failingItems {
            let failureView = BusinessRuleFailureView()
            failureView.setup(failure: item)
            businessRuleFailures.addArrangedSubview(failureView)
        }
        businessRuleFailures.addArrangedSubview(getSpacer(height: showAsFailed ? 24 : 36))
        
        let colour = isSpecimen ? Theme.colors.greenGrey : showAsFailed ? Theme.colors.denied : Theme.colors.access
        subviews.first?.backgroundColor = colour
        accessBackgroundView.backgroundColor = colour
        scrollView.addHeaderColor(colour)
        accessLabel.text = (showAsFailed ? "travel_not_met" : "travel_met").localized()
        accessImageView.image = UIImage(named: showAsFailed ? "denied_inverted" : "access_inverted")
        
        dccNameLabel.font = Theme.fonts.title1
        dateOfBirthLabel.font = Theme.fonts.subheadBoldMontserrat
        dccNameLabel.text = dcc.getName()
        if let dccData = dcc.dcc, let dob = dccData.getDateOfBirth() {
            dateOfBirthLabel.text = "item_date_of_birth_x".localized(params: dateFormat.string(from: dob))
        } else {
            dateOfBirthLabel.text = "item_date_of_birth_x".localized(params: dcc.dcc?.dateOfBirth ?? "item_unknown".localized())
        }
        setupVaccineViews(dcc: dcc)
        setupTests(dcc: dcc)
        setupRecoveries(dcc: dcc)
	}
    
    func updateCountryPicker(settings: UserSettings) {
        getSelectedCountryView().setup(departure: settings.lastDeparture, destination: settings.lastDestination)
    }
    
    func setupRecoveries(dcc: DCCQR) {
        guard let recoveries = dcc.dcc?.recoveries else { return }
        for recovery in recoveries {
            let header = ResultRecoveryView()
            header.setup(recovery: recovery, dateFormat: dateFormat)
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
    
    func setupTests(dcc: DCCQR) {
        guard let tests = dcc.dcc?.tests else { return }
        for test in tests {
            let header = ResultTestView()
            header.setup(test: test, dateFormat: dateFormat)
            itemsStack.addArrangedSubview(header)

            itemsStack.addArrangedSubview(getItem(key: "item_test_target".localized(), value: test.getTargetedDisease?.displayName ?? test.targetedDisease))
            
            itemsStack.addArrangedSubview(getItem(key: "item_test_type".localized(), value: test.getTestType?.displayName ?? test.typeOfTest))
            
            itemsStack.addArrangedSubview(getItem(key: "item_test_name".localized(), value: test.NAATestName ?? ""))
            itemsStack.addArrangedSubview(getItem(key: "item_test_manufacturer".localized(), value: test.getTestManufacturer?.displayName ?? test.RATTestNameAndManufac ?? ""))

            itemsStack.addArrangedSubview(getItem(key: "item_test_location".localized(), value: test.testingCentre ?? ""))
            itemsStack.addArrangedSubview(getItem(key: "item_test_country".localized(), value: test.countryOfTest))
            itemsStack.addArrangedSubview(getItem(key: "item_certificate_issuer".localized(), value: test.certificateIssuer))
            itemsStack.addArrangedSubview(getItem(key: "item_identifier".localized(), value: test.certificateIdentifier))
        }
    }
    
    func setupVaccineViews(dcc: DCCQR) {
        if let vaccines = dcc.dcc?.vaccines {
            
            if vaccines.count >= 1 {
                vaccineView1.setup(vaccine: vaccines[0], dateFormat: dateFormat)
                vaccineView1.isHidden = false
                addVaccineMeta(vaccine: vaccines[0], hasHeader: vaccines.count > 1)
            } else {
                vaccineView1.isHidden = true
            }
            if vaccines.count >= 2 {
                vaccineView2.setup(vaccine: vaccines[1], dateFormat: dateFormat)
                vaccineView2.isHidden = false
                addVaccineMeta(vaccine: vaccines[1], hasHeader: vaccines.count > 1)
            } else {
                vaccineView2.isHidden = true
            }
        } else {
            vaccineView2.isHidden = true
            vaccineView1.isHidden = true
            vaccinesStack.isHidden = true
        }
    }
    
    func addVaccineMeta(vaccine: DCCVaccine, hasHeader: Bool) {
        var targetString = ""
        if hasHeader {
            itemsStack.addArrangedSubview(getItemHeader(title: "item_dose_x".localized(params: vaccine.doseNumber)))
        }
        targetString += "\(vaccine.getTargetedDisease?.displayName ?? vaccine.targetedDisease)"
        if targetString != "" {
            targetString += " | "
        }
        targetString += vaccine.getVaccine?.displayName ?? vaccine.vaccine
        itemsStack.addArrangedSubview(getItem(key: "item_disease".localized(), value: targetString))
        itemsStack.addArrangedSubview(getItem(key: "item_country".localized(), value: vaccine.countryOfVaccination))
        itemsStack.addArrangedSubview(getItem(key: "item_test_manufacturer".localized(), value: vaccine.getMarketingHolder?.displayName ?? vaccine.marketingAuthorizationHolder))
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
