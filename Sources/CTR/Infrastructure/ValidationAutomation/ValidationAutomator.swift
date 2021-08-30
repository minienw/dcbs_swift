//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation
import CoreImage
import UIKit

class ValidationAutomator {
    
    static let instance = ValidationAutomator()
    
    let cryptoManager = Services.cryptoManager
    let versionSupplier = AppVersionSupplier()
    let mainBaseUrl = "https://raw.githubusercontent.com/eu-digital-green-certificates/dcc-quality-assurance/validation5/"
    
    var result = ""
    var reports = [String]()
    
    let qrCodeUrls = [ "$baseAT/1.0.0/TEST.png", "$baseAT/1.3.0/TEST.png", "$baseAT/1.0.0/VAC.png", "$baseAT/1.3.0/VAC.png", "$baseAT/1.0.0/REC.png", "$baseAT/1.3.0/REC.png", "$baseBE/1.0.1/TEST.png", "$baseBE/1.3.0/TEST.png", "$baseBE/1.0.1/VAC.png", "$baseBE/1.3.0/VAC.png", "$baseBE/1.0.1/REC.png", "$baseBE/1.3.0/REC.png", "$baseBE/1.3.0/specialcases/VAC_INCOMPLETE_DOB.png", "$baseBG/1.0.0/VAC.png", "$baseBG/1.3.0/VAC.png", "$baseBG/1.0.0/REC.png", "$baseBG/1.3.0/REC.png", "$baseBG/1.3.0/specialcases/TEST.png", "$baseBG/1.0.0/specialcases/VAC-NULL-DATETIME.png", "$baseBG/1.0.0/specialcases/REC-NULL-DATETIME.png", "$baseBG/1.0.0/specialcases/REC-VALID-BEFORE-DSC.png", "$baseBG/1.3.0/specialcases/REC-VALID-BEFORE-DSC.png", "$baseCH/1.2.1/VAC.png", "$baseCH/1.3.0/VAC.png", "$baseCH/1.2.1/REC.png", "$baseCH/1.3.0/REC.png", "$baseCH/1.2.1/specialcases/TEST_CH_BAG.png", "$baseCH/1.2.1/specialcases/TEST_ma_field_empty.png", "$baseCH/1.3.0/specialcases/TEST_empty_ma_field.png", "$baseCH/1.2.1/specialcases/VAC_CH_BAG.png", "$baseCH/1.2.1/specialcases/REC_CH_BAG.png", "$baseCY/1.0.0/TEST.png", "$baseCY/1.3.0/TEST.png", "$baseCY/1.0.0/VAC.png", "$baseCY/1.3.0/VAC.png", "$baseCY/1.0.0/REC.png", "$baseCY/1.3.0/REC.png", "$baseCZ/1.0.1/TEST.png", "$baseCZ/1.3.0/TEST.png", "$baseCZ/1.0.1/VAC.png", "$baseCZ/1.3.0/VAC.png", "$baseCZ/1.0.1/REC.png", "$baseCZ/1.3.0/REC.png", "$baseCZ/1.3.0/specialcases/TEST_ma_wrong_value.png", "$baseDE/1.0.0/TEST.png", "$baseDE/1.0.0/VAC.png", "$baseDE/1.0.0/REC.png", "$baseDK/1.3.0/TEST-AG.png", "$baseDK/1.3.0/TEST-PCR.png", "$baseDK/1.3.0/VAC.png", "$baseDK/1.3.0/REC.png", "$baseEE/1.0.0/TEST.png", "$baseEE/1.3.0/TEST.png", "$baseEE/1.0.0/VAC.png", "$baseEE/1.3.0/VAC.png", "$baseEE/1.0.0/REC.png", "$baseEE/1.3.0/REC.png", "$baseEL/1.0.0/TEST.png", "$baseEL/1.3.0/TEST_PCR_v1.3_2021-07-20.png", "$baseEL/1.3.0/TEST_RAT_v1.3_2021-07-20.png", "$baseEL/1.0.0/VAC.png", "$baseEL/1.3.0/VAC.png", "$baseEL/1.3.0/VAC_JANSSEN_v1.3_2021-07-20.png", "$baseEL/1.3.0/VAC_MODERNA_v1.3_2021-07-20.png", "$baseEL/1.3.0/VAC_rec_v1.3_2021-07-20.png", "$baseEL/1.0.0/REC.png", "$baseEL/1.3.0/REC.png", "$baseES/1.3.0/TEST_NAAT.png", "$baseES/1.3.0/TEST_RAT.png", "$baseES/1.3.0/VAC.png", "$baseES/1.3.0/REC.png", "$baseES/1.3.0/specialcases/TEST_NAAT_2.png", "$baseES/1.3.0/specialcases/TEST_RAT_2.png", "$baseES/1.3.0/specialcases/VAC_1.png", "$baseES/1.3.0/specialcases/VAC_2.png", "$baseES/1.3.0/specialcases/VAC_3.png", "$baseES/1.3.0/specialcases/REC_1.png", "$baseES/1.3.0/specialcases/REC_2.png", "$baseES/1.3.0/specialcases/REC_3.png", "$baseES/1.3.0/specialcases/REC_4.png", "$baseFI/1.3.0/TEST1.png", "$baseFI/1.3.0/TEST2.png", "$baseFI/1.0.0/VAC.png", "$baseFI/1.3.0/VAC1.png", "$baseFI/1.3.0/VAC2.png", "$baseFI/1.3.0/VAC3.png", "$baseFI/1.3.0/REC.png", "$baseFO/1.3.0/TEST.png", "$baseFO/1.3.0/VAC.png", "$baseFR/1.3.0/TEST.png", "$baseFR/1.0.0/VAC.png", "$baseFR/1.3.0/specialcases/VAC.png", "$baseHR/1.0.0/TEST.png", "$baseHR/1.3.0/TEST.png", "$baseHR/1.0.0/VAC.png", "$baseHR/1.3.0/VAC.png", "$baseHR/1.3.0/VAC_1DOSE.png", "$baseHR/1.0.0/REC.png", "$baseHR/1.3.0/REC.png", "$baseHU/1.3.0/TEST_NAAT.png", "$baseHU/1.3.0/VAC.png", "$baseHU/1.3.0/REC.png", "$baseHU/1.3.0/specialcases/TEST_RAT.png", "$baseIE/1.3.0/TEST_NAT.png", "$baseIE/1.3.0/TEST_RAT.png", "$baseIE/1.3.0/VAC.png", "$baseIE/1.3.0/REC.png", "$baseIS/1.3.0/TEST_PCR.png", "$baseIS/1.3.0/TEST_RAT.png", "$baseIS/1.3.0/VAC.png", "$baseIS/1.3.0/REC.png", "$baseIT/1.0.0/TEST.png", "$baseIT/1.3.0/TEST.png", "$baseIT/1.0.0/VAC.png", "$baseIT/1.3.0/VAC.png", "$baseIT/1.0.0/REC.png", "$baseIT/1.3.0/REC.png", "$baseIT/1.3.0/specialcases/TEST_NAAT.png", "$baseIT/1.0.0/specialcases/VAC_DOSE_1.png", "$baseIT/1.3.0/specialcases/VAC_DOSE_1.png", "$baseLI/1.1.0/TEST.png", "$baseLI/1.3.0/TEST.png", "$baseLI/1.1.0/VAC.png", "$baseLI/1.3.0/VAC.png", "$baseLI/1.1.0/REC.png", "$baseLI/1.3.0/REC.png", "$baseLT/1.0.0/TEST.png", "$baseLT/1.3.0/TEST-NAAT.png", "$baseLT/1.3.0/TEST-RAT.png", "$baseLT/1.0.0/VAC.png", "$baseLT/1.3.0/VAC.png", "$baseLT/1.0.0/REC.png", "$baseLT/1.3.0/REC.png", "$baseLU/1.3.0/TEST_NAAT.png", "$baseLU/1.3.0/TEST_RAT.png", "$baseLU/1.3.0/VAC_standard.png", "$baseLU/1.3.0/REC_standard.png", "$baseLU/1.3.0/specialcases/VAC_noday.png", "$baseLU/1.3.0/specialcases/VAC_nomonth.png", "$baseLU/1.3.0/specialcases/VAC_noyear.png", "$baseLU/1.3.0/specialcases/REC_nomonth.png", "$baseLV/1.0.0/TEST.png", "$baseLV/1.3.0/TEST.png", "$baseLV/1.0.0/VAC.png", "$baseLV/1.0.0/VAC2.png", "$baseLV/1.3.0/VAC.png", "$baseLV/1.0.0/REC.png", "$baseLV/1.3.0/REC.png", "$baseLV/1.0.0/specialcases/TEST_NULL_values_in_nm_ma.png", "$baseLV/1.0.0/specialcases/TEST_without_issuer.png", "$baseLV/1.3.0/specialcases/TEST_in_other_country.png", "$baseLV/1.0.0/specialcases/VAC_not_allowed_characters_in_fnt.png", "$baseLV/1.3.0/specialcases/VAC_in_other_country.png", "$baseLV/1.0.0/specialcases/REC_df_minu_fr_equals_9.png", "$baseLV/1.3.0/specialcases/REC_in_other_country.png", "$baseMK/1.3.0/TEST.png", "$baseMK/1.3.0/VAC.png", "$baseMK/1.3.0/REC.png", "$baseMT/1.3.0/VAC.png", "$baseNL/1.3.0/TEST.png", "$baseNL/1.0.0/VAC.png", "$baseNL/1.3.0/VAC.png", "$baseNL/1.3.0/VAC_AW.png", "$baseNL/1.3.0/VAC_CW.png", "$baseNL/1.3.0/VAC_SX.png", "$baseNL/1.3.0/REC.png", "$baseNL/1.3.0/specialcases/VAC_JANSSEN_2_of_1.png", "$baseNL/1.3.0/specialcases/VAC_PFIZER_1_of_1.png", "$baseNL/1.3.0/specialcases/VAC_PFIZER_3_of_2.png", "$baseNL/1.3.0/specialcases/VAC_PFIZER_3_of_3.png", "$baseNO/1.3.0/TEST.png", "$baseNO/1.3.0/VAC.png", "$baseNO/1.3.0/REC.png", "$baseNO/1.3.0/specialcases/VAC_NONDIGITALCITIZEN.png", "$baseNO/1.3.0/specialcases/REC_NONDIGITALCITIZEN.png", "$basePL/1.0.0/TEST.png", "$basePL/1.0.0/VAC.png", "$basePL/1.0.0/REC.png", "$basePL/1.0.0/specialcases/VAC-11.png", "$basePL/1.0.0/specialcases/VAC-12.png", "$basePL/1.0.0/specialcases/VAC-13.png", "$basePT/1.0.0/TEST.png", "$basePT/1.3.0/TEST.png", "$basePT/1.0.0/VAC.png", "$basePT/1.3.0/VAC.png", "$basePT/1.0.0/REC.png", "$basePT/1.3.0/REC.png", "$baseRO/1.3.0/TEST.png", "$baseRO/1.3.0/VAC.png", "$baseRO/1.3.0/REC.png", "$baseRO/1.3.0/specialcases/VAC-11.png", "$baseRO/1.3.0/specialcases/VAC-12.png", "$baseSE/1.3.0/TEST.png", "$baseSE/1.3.0/VAC.png", "$baseSE/1.3.0/REC.png", "$baseSI/1.0.0/TEST.png", "$baseSI/1.3.0/test-AG.png", "$baseSI/1.3.0/test-PCR.png", "$baseSI/1.0.0/VAC.png", "$baseSI/1.3.0/VAC.png", "$baseSI/1.0.0/REC.png", "$baseSI/1.3.0/REC.png", "$baseSK/1.3.0/TEST.png", "$baseSK/1.2.1/VAC.png", "$baseSK/1.2.1/REC.png", "$baseSM/1.3.0/TEST.png", "$baseSM/1.3.0/VAC.png", "$baseSM/1.3.0/REC.png", "$baseSM/1.3.0/specialcases/TEST.png", "$baseTR/1.3.0/TEST.png", "$baseTR/1.3.0/VAC.png", "$baseTR/1.3.0/REC.png", "$baseUA/1.3.0/TEST.png", "$baseUA/1.3.0/VAC.png", "$baseUA/1.3.0/REC.png", "$baseVA/1.3.0/TEST.png", "$baseVA/1.3.0/VAC.png", "$baseVA/1.3.0/REC.png", "$baseTSI/1.3.0/TEST_1.png", "$baseTSI/1.3.0/TEST_2.png", "$baseTSI/1.3.0/TEST_3.png", "$baseTSI/1.3.0/TEST_4.png", "$baseTSI/1.3.0/VAC_1.png", "$baseTSI/1.3.0/VAC_2.png", "$baseTSI/1.3.0/VAC_3.png", "$baseTSI/1.3.0/VAC_4.png", "$baseTSI/1.3.0/VAC_5.png", "$baseTSI/1.3.0/REC_1.png", "$baseTSI/1.3.0/REC_2.png", "$baseTSI/1.3.0/MULTI_1.png", "$baseTSI/1.3.0/MULTI_2.png"]
    
    func runValidation(from: UIViewController?) {
        let dispatchGroup = DispatchGroup()
        
        result += "Country,Version,QR,Result,Remark\n"
        for item in qrCodeUrls {
            let finalURL = item.replacingOccurrences(of: "$base", with: mainBaseUrl)
            handle(url: URL(string: finalURL), dispatchGroup: dispatchGroup)
        }
        dispatchGroup.notify(queue: .main) {
            print(self.result)
            let ac = UIActivityViewController(activityItems: [self.writeReport()], applicationActivities: nil)
            from?.present(ac, animated: true)
        }
    }
    
    func handle(url: URL?, dispatchGroup: DispatchGroup) {
        guard let url = url else { return }
        dispatchGroup.enter()
        getQR(url: url) { it in
            if let image = it {
                if let qr = self.decodeQR(image: image) {
                    if let error = self.validateQR(qr: qr) {
                        self.report(url: url, status: "Failed", remark: error)
                    } else {
                        self.report(url: url, status: "Success", remark: "")
                    }
                } else {
                    self.report(url: url, status: "Failed", remark: "Not a QR Code")
                }
            } else {
                print("Image not found for: \(url.absoluteString)")
            }
            dispatchGroup.leave()
        }
    }

    func writeReport() -> URL {
        
        let sortedReports = reports.sorted { it1, it2 in
            it1 < it2
        }
        for item in sortedReports {
            result += item
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let reportDate = Date()
        let fileName = "Validation Report D\(formatter.string(from: reportDate)) V\(versionSupplier.getCurrentVersion()) B\(versionSupplier.getCurrentBuild()) iOS.csv"
        
        let file = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try result.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
        return file
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func report(url: URL, status: String, remark: String) {
        print("Report: \(url.absoluteString), \(status), \(remark)")
        let item = url.absoluteString.replacingOccurrences(of: mainBaseUrl, with: "").replacingOccurrences(of: ".png?raw=true", with: "")
        let strippedItems = item.split(maxSplits: 2, omittingEmptySubsequences: true, whereSeparator: { $0 == "/" })
        reports.append("\(strippedItems[0]),\(strippedItems[1]),\(strippedItems[2]),\(status),\(remark)\n")
    }
    
    func validateQR(qr: String) -> String? {
        let cryptoResults = cryptoManager.verifyQRMessage(qr)
        if let error = cryptoResults.1 {
            return error
        }
        if cryptoResults.0 == nil {
            return "Unknown error"
        }
        return nil
    }
    
    private func decodeQR(image: UIImage) -> String? {
        guard let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]),
              let ciImage: CIImage = CIImage(image: image),
              let features = detector.features(in: ciImage) as? [CIQRCodeFeature] else {
            return nil
        }
        var result = ""
        features.forEach { feature in
            if let messageString = feature.messageString {
                result += messageString
            }
        }
        return result
    }
    
    private func getQR(url: URL, result: @escaping ((UIImage?) -> Void)) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                result(UIImage(data: data))
            }
        }
    }
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
