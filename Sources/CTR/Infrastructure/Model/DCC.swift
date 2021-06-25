//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

struct DCCQR: Codable {
    
    static var dateFormat: ISO8601DateFormatter {
        return ISO8601DateFormatter()
    }
    
    static var dateFormatBackup: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }
   
    let credentialVersion: Int? // Version of this QR
    private let issuer: String? // Country for example France
    let issuedAt: TimeInterval? // When was this QR issued at in seconds
    let expirationTime: TimeInterval? // When does this QR expire in seconds
    
    let dcc: DCC?
    
    func getName() -> String {
        return "\((dcc?.name.getLastName() ?? "").capitalized) \((dcc?.name.firstName ?? "").capitalized) "
    }
    
    var isSpecimen: Bool {
        return expirationTime == 42
    }
    
    var isDomesticDcc: Bool {
        return false
    }
    
    func getYearsOld() -> Int? {
        guard let userDOB = dcc?.getDateOfBirth() else { return nil }
        return Calendar.current.dateComponents([.year], from: userDOB, to: Date()).year
    }
    
    var isVerified: Bool {
        guard let dcc = dcc else { return false }
        if dcc.vaccines?.isEmpty == true && dcc.recoveries?.isEmpty == true && dcc.tests?.isEmpty == true {
            return false
        }
        return true
    }
    
    func processBusinessRules(from: CountryColorCode, to: String) -> [DCCFailableItem] {
        var failingItems = [DCCFailableItem]()
        let toCode = to.lowercased()
        if toCode == "nl" {
            let items = processNLBusinessRules(from: from, to: toCode)
            if !items.isEmpty {
                failingItems.append(contentsOf: items)
            }
        }
        return failingItems
    }
    
    private func processNLBusinessRules(from: CountryColorCode, to: String) -> [DCCFailableItem] {
        var failingItems = [DCCFailableItem]()
        if from == .green || from == .yellow {
            return []
        }
        if from == .red {
            return [.redNotAllowed]
        }
        if let yearsOld = getYearsOld(), yearsOld <= 11, from != .orangeHighShipsFlight {
            return []
        }
        
        if dcc?.tests == nil || dcc?.tests?.isEmpty == true {
            failingItems.append(.missingRequiredTest)
        }
        if from == .orange {
            for vaccine in dcc?.vaccines ?? [] {
                if vaccine.isFullyVaccinated() {
                    return []
                } else {
                    return [.needFullVaccination]
                }
            }
            for recovery in dcc?.recoveries ?? [] {
                if recovery.isValidRecovery(date: Date()) {
                    return []
                } else {
                    return [.recoveryNotValid]
                }
            }
        }
        for test in dcc?.tests ?? [] {
            if test.getTestResult != .notDetected {
                failingItems.append(.testMustBeNegative)
            }
            if let item = test.getTestIssues(from: from, to: to) {
                failingItems.append(item)
            }
        }
        if from == .orangeHighShipsFlight {
            failingItems.append(.requireSecondTest(hours: 24, type: .rapidImmune))
        }
        return failingItems
    }
    
}

struct DCC: Codable {
    /// DCC version
    let version: String
    /// Date of birth 1962-07-01
    let dateOfBirth: String
    /// Name object
    let name: DCCNameObject
    /// Vaccine array
    let vaccines: [DCCVaccine]?
    /// Tests
    let tests: [DCCTest]?
    /// Recoveries
    let recoveries: [DCCRecovery]?
    
    enum CodingKeys: String, CodingKey {
        case version = "ver"
        case dateOfBirth = "dob"
        case name = "nam"
        case vaccines = "v"
        case tests = "t"
        case recoveries = "r"
    }
    
    func getDateOfBirth() -> Date? {
        let firstPass = DCCQR.dateFormat.date(from: dateOfBirth)
        let secondPass = DCCQR.dateFormatBackup.date(from: dateOfBirth)
        return firstPass ?? secondPass
    }
}

struct DCCNameObject: Codable {
    /// First name
    let firstName: String?
    /// Last name
    let lastName: String?
    
    let lastNameStandardised: String
    
    func getLastName() -> String {
        return lastName ?? lastNameStandardised.lowercased().capitalized
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "fn"
        case lastName = "gn"
        case lastNameStandardised = "gnt"
    }
}

struct DCCVaccine: Codable {
    private let targetedDisease: String
    private let vaccine: String
    private let vaccineMedicalProduct: String // EU1/20/1507 (vaccine model?)
    private let marketingAuthorizationHolder: String // ORG-100031184 issuer?
    let doseNumber: Int
    let totalSeriesOfDoses: Int
    let dateOfVaccination: String // Date
    let countryOfVaccination: String // Country Code
    let certificateIssuer: String //
    let certificateIdentifier: String //
    
    var getVaccine: VaccineProphylaxis? {
        return VaccineProphylaxis(rawValue: vaccine)
    }
    
    var getVaccineProduct: VaccineProduct? {
        return VaccineProduct(rawValue: vaccineMedicalProduct)
    }
    
    var getTargetedDisease: TargetedDisease? {
        return TargetedDisease(rawValue: targetedDisease)
    }
    
    var getMarketingHolder: VaccineHolder? {
        return VaccineHolder(rawValue: marketingAuthorizationHolder)
    }
    
    func getDateOfVaccination() -> Date? {
        return DCCQR.dateFormat.date(from: dateOfVaccination) ?? DCCQR.dateFormatBackup.date(from: dateOfVaccination)
    }
    
    func isFullyVaccinated() -> Bool {
        return doseNumber == totalSeriesOfDoses
    }
    
    enum CodingKeys: String, CodingKey {
        case targetedDisease = "tg"
        case vaccine = "vp"
        case vaccineMedicalProduct = "mp"
        case marketingAuthorizationHolder = "ma"
        case doseNumber = "dn"
        case totalSeriesOfDoses = "sd"
        case dateOfVaccination = "dt"
        case countryOfVaccination = "co"
        case certificateIssuer = "is"
        case certificateIdentifier = "ci"
    }
}

struct DCCTest: Codable {
    
    private let targetedDisease: String
    private let typeOfTest: String
    let NAATestName: String?
    private let RATTestNameAndManufac: String?
    let dateOfSampleCollection: String
    private let testResult: String
    let testingCentre: String?
    let countryOfTest: String
    let certificateIssuer: String
    let certificateIdentifier: String
    
    var getTargetedDisease: TargetedDisease? {
        return TargetedDisease(rawValue: targetedDisease)
    }
    
    var getTestResult: DCCTestResult? {
        return DCCTestResult(rawValue: testResult)
    }
    
    var getTestManufacturer: DCCTestManufacturer? {
        guard let manuf = RATTestNameAndManufac else { return nil }
        return DCCTestManufacturer(rawValue: manuf)
    }
    
    var getTestType: DCCTestType? {
        return DCCTestType(rawValue: typeOfTest)
    }
    
    func getDateOfTest() -> Date? {
        return DCCQR.dateFormat.date(from: dateOfSampleCollection) ?? DCCQR.dateFormatBackup.date(from: dateOfSampleCollection)
    }
    
    func getTestIssues(from: CountryColorCode, to: String) -> DCCFailableItem? {
        if let type = getTestType, let dateOfTest = getDateOfTest(), let hoursDifference = Calendar.current.dateComponents([.hour], from: dateOfTest, to: Date()).hour {
            if let maxHours = type.validFor(country: to) {
                if hoursDifference > maxHours {
                    return .testDateExpired(hours: maxHours)
                }
            }
        } else {
            return .testDateExpired(hours: 72)
        }
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case targetedDisease = "tg"
        case typeOfTest = "tt"
        case NAATestName = "nm"
        case RATTestNameAndManufac = "ma"
        case dateOfSampleCollection = "sc"
        case testResult = "tr"
        case testingCentre = "tc"
        case countryOfTest = "co"
        case certificateIssuer = "is"
        case certificateIdentifier = "ci"
    }
    
}

struct DCCRecovery: Codable {
    
    private let targetedDisease: String
    let dateOfFirstPositiveTest: String
    let countryOfTest: String
    let certificateIssuer: String
    let certificateValidFrom: String
    let certificateValidTo: String
    let certificateIdentifier: String
    
    var getTargetedDisease: TargetedDisease? {
        return TargetedDisease(rawValue: targetedDisease)
    }
    
    func getDateOfFirstPositiveTest() -> Date? {
        return DCCQR.dateFormat.date(from: dateOfFirstPositiveTest) ?? DCCQR.dateFormatBackup.date(from: dateOfFirstPositiveTest)
    }
    
    func getDateValidFrom() -> Date? {
        return DCCQR.dateFormat.date(from: certificateValidFrom) ?? DCCQR.dateFormatBackup.date(from: certificateValidFrom)
    }
    
    func getDateValidTo() -> Date? {
        return DCCQR.dateFormat.date(from: certificateValidTo) ?? DCCQR.dateFormatBackup.date(from: certificateValidTo)
    }
    
    func isValidRecovery(date: Date) -> Bool {
        guard let from = getDateValidFrom(), let to = getDateValidTo() else { return false }
        let nowTime = date.timeIntervalSince1970
        return nowTime >= from.timeIntervalSince1970 && nowTime <= to.timeIntervalSince1970
    }
    
    enum CodingKeys: String, CodingKey {
        case targetedDisease = "tg"
        case dateOfFirstPositiveTest = "fr"
        case countryOfTest = "co"
        case certificateIssuer = "is"
        case certificateValidFrom = "df"
        case certificateValidTo = "du"
        case certificateIdentifier = "ci"
    }
    
}
