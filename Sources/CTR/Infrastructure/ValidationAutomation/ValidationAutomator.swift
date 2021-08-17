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
    let mainBaseUrl = "https://github.com/eu-digital-green-certificates/dcc-quality-assurance/blob/main/"
    
    var result = ""
    var reports = [String]()
    
    func getTestData() -> [String]? {
        guard let path = Bundle.main.url(forResource: "validate-qrs", withExtension: "json") else { return [] }
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode([String].self, from: Data(contentsOf: path))
    }
    
    func runValidation(from: UIViewController?) {
        guard let data = getTestData() else {
            return
        }
        let schemes = ["1.0.0", "1.0.1", "1.2.1", "1.3.0"]
        let dispatchGroup = DispatchGroup()
        
        result += "QR,Result,Remark\n"
        for item in data {
            for scheme in schemes {
                let baseURL = "\(mainBaseUrl)\(item)/\(scheme)"
                handle(url: URL(string: "\(baseURL)/REC.png?raw=true"), dispatchGroup: dispatchGroup)
                handle(url: URL(string: "\(baseURL)/VAC.png?raw=true"), dispatchGroup: dispatchGroup)
                handle(url: URL(string: "\(baseURL)/TEST.png?raw=true"), dispatchGroup: dispatchGroup)
            }
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
        let item = url.absoluteString.replacingOccurrences(of: mainBaseUrl, with: "").replacingOccurrences(of: ".png?raw=true", with: "")
        reports.append("\(item),\(status),\(remark)\n")
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
