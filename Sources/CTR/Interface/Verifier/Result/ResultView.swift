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
    
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var dccNameLabel: UILabel!
    @IBOutlet var dateOfBirthLabel: UILabel!
    @IBOutlet var vaccinesStack: UIStackView!
    @IBOutlet var itemsStack: UIStackView!
    
    var onTappedNextScan: (() -> Void)?
    
    func setupForVerified(dcc: DCCQR) {
        deniedView.isHidden = true
        accessView.isHidden = false
		
        dccNameLabel.text = dcc.getName()
        dateOfBirthLabel.text = "item_date_of_birth_x".localized(params: dcc.getBirthDate())
        setupVaccineViews(dcc: dcc)
        setupTests(dcc: dcc)
        setupRecoveries(dcc: dcc)
        destinationLabel.text = "destination_x".localized(params: "Nederland")
	}
    
    func setupRecoveries(dcc: DCCQR) {
        guard let recoveries = dcc.dcc?.recoveries else { return }
        for recovery in recoveries {
            if let target = recovery.getTargetedDisease {
                let header = ResultRecoveryView()
                header.setup(disease: target)
                itemsStack.addArrangedSubview(header)
            } else {
                itemsStack.addArrangedSubview(getItemHeader(title: "item_recovery_header".localized()))
            }
            
            if let first = recovery.dateOfFirstPositiveTest {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_first_date".localized(), value: first))
            }
            if let from = recovery.certificateValidFrom {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_from".localized(), value: from))
            }
            if let to = recovery.certificateValidTo {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_to".localized(), value: to))
            }
            if let country = recovery.countryOfTest {
                itemsStack.addArrangedSubview(getItem(key: "item_recovery_country".localized(), value: country))
            }
            if let issuer = recovery.certificateIssuer {
                itemsStack.addArrangedSubview(getItem(key: "item_certificate_issuer".localized(), value: issuer))
            }
            if let certificate = recovery.certificateIdentifier {
                itemsStack.addArrangedSubview(getItem(key: "item_identifier".localized(), value: certificate))
            }
        }
    }
    
    func setupTests(dcc: DCCQR) {
        guard let tests = dcc.dcc?.tests else { return }
        for test in tests {
            let header = ResultTestView()
            header.setup(test: test)
            itemsStack.addArrangedSubview(header)

            if let target = test.getTargetedDisease {
                itemsStack.addArrangedSubview(getItem(key: "item_test_target".localized(), value: target.rawValue))
            }
            if let prophylaxis = test.getTestType {
                itemsStack.addArrangedSubview(getItem(key: "item_test_type".localized(), value: prophylaxis.displayName))
            }
            if let naaTestName = test.NAATestName {
                itemsStack.addArrangedSubview(getItem(key: "item_test_name".localized(), value: naaTestName))
            }
            if let manuf = test.getTestManufacturer {
                itemsStack.addArrangedSubview(getItem(key: "item_test_manufacturer".localized(), value: manuf.displayName))
            }
            if let location = test.testingCentre {
                itemsStack.addArrangedSubview(getItem(key: "item_test_location".localized(), value: location))
            }
            if let country = test.countryOfTest {
                itemsStack.addArrangedSubview(getItem(key: "item_test_country".localized(), value: country))
            }
            if let issuer = test.certificateIssuer {
                itemsStack.addArrangedSubview(getItem(key: "item_certificate_issuer".localized(), value: issuer))
            }
            if let identifier = test.certificateIdentifier {
                itemsStack.addArrangedSubview(getItem(key: "item_identifier".localized(), value: identifier))
            }
        }
    }
    
    func setupVaccineViews(dcc: DCCQR) {
        if let vaccines = dcc.dcc?.vaccines {
            
            if vaccines.count >= 1 {
                vaccineView1.setup(vaccine: vaccines[0])
                vaccineView1.isHidden = false
                addVaccineMeta(vaccine: vaccines[0], hasHeader: vaccines.count > 1)
            } else {
                vaccineView1.isHidden = true
            }
            if vaccines.count >= 2 {
                vaccineView2.setup(vaccine: vaccines[1])
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
            if let dose = vaccine.doseNumber {
                itemsStack.addArrangedSubview(getItemHeader(title: "item_dose_x".localized(params: dose)))
            }
        }
        if let target = vaccine.getTargetedDisease {
            targetString += "\(target.displayName)"
        }
        if let prophylaxis = vaccine.getVaccine {
            if targetString != "" {
                targetString += " | "
            }
            targetString += prophylaxis.displayName
        }
        if targetString != "" {
            itemsStack.addArrangedSubview(getItem(key: "item_disease".localized(), value: targetString))
        }
        if let country = vaccine.countryOfVaccination {
            itemsStack.addArrangedSubview(getItem(key: "item_country".localized(), value: country))
        }
        if let issuer = vaccine.certificateIssuer {
            itemsStack.addArrangedSubview(getItem(key: "item_certificate_issuer".localized(), value: issuer))
        }
        if let identifier = vaccine.certificateIdentifier {
            itemsStack.addArrangedSubview(getItem(key: "item_identifier".localized(), value: identifier))
        }
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
	}

	func revealIdentityView(_ onCompletion: (() -> Void)? = nil) {

        onCompletion?()
	}
    
    @IBAction func nextScanTapped(_ sender: Any) {
        onTappedNextScan?()
    }
    
}
