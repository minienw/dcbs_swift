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
    
    init(dcc: DCC, expireTime: TimeInterval) {
        credentialVersion = nil
        issuer = "nl"
        issuedAt = Date().timeIntervalSince1970
        expirationTime = expireTime
        self.dcc = dcc
    }
    
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
    
    func getYearOfBirth() -> Int? {
        guard let userDOB = dcc?.getDateOfBirth() else { return nil }
        let date = Calendar.current.dateComponents([.year], from: userDOB)
        return date.year
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
        let generalItems = processGeneralRules()
        if !generalItems.isEmpty {
            failingItems.append(contentsOf: generalItems)
        }
        let toCode = to.lowercased()
        if toCode == "nl" {
            let items = processNLBusinessRules(from: from, to: toCode)
            if !items.isEmpty {
                failingItems.append(contentsOf: items)
            }
        }
        return failingItems
    }
    
    private func processGeneralRules() -> [DCCFailableItem] {
        var failingItems = [DCCFailableItem]()
        if let yearOfBirth = getYearOfBirth() {
            if yearOfBirth < 1900 || yearOfBirth > 2099 {
                failingItems.append(.dateOfBirthOutOfRange)
            }
        }
        if dcc?.getDateOfBirth() == nil {
            failingItems.append(.invalidDateOfBirth)
        }
        for vaccin in dcc?.vaccines ?? [] {
            if (vaccin.getVaccinationAge()?.day ?? 0) < 14 {
                failingItems.append(.vaccinationMustBe14DaysOld)
            }
            if vaccin.getMarketingHolder == nil {
                failingItems.append(.invalidVaccineHolder)
            }
            if vaccin.getVaccine == nil {
                failingItems.append(.invalidVaccineType)
            }
            if vaccin.getVaccineProduct == nil {
                failingItems.append(.invalidVaccineProduct)
            }
            if !vaccin.isCountryValid() {
                failingItems.append(.invalidCountryCode)
            }
            if vaccin.getDateOfVaccination() == nil {
                failingItems.append(.invalidVaccineDate)
            }
        }
        for test in dcc?.tests ?? [] {
            if test.getTestResult == nil {
                failingItems.append(.invalidTestResult)
            }
            if test.getTestType == nil {
                failingItems.append(.invalidTestType)
            }
            if test.getTargetedDisease == nil {
                failingItems.append(.invalidTargetDisease)
            }
            if !test.isCountryValid() {
                failingItems.append(.invalidCountryCode)
            }
            if test.getDateOfTest() == nil {
                failingItems.append(.invalidTestDate)
            }
        }
        for recovery in dcc?.recoveries ?? [] {
            if recovery.getTargetedDisease == nil {
                failingItems.append(.invalidTargetDisease)
            }
            if !recovery.isCountryValid() {
                failingItems.append(.invalidCountryCode)
            }
            if recovery.getDateValidTo() == nil {
                failingItems.append(.invalidRecoveryToDate)
            }
            if recovery.getDateValidFrom() == nil {
                failingItems.append(.invalidRecoveryFromDate)
            }
            if recovery.getDateOfFirstPositiveTest() == nil {
                failingItems.append(.invalidRecoveryFirstTestDate)
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
    
    init(version: String, dateOfBirth: String, name: DCCNameObject, vaccine: DCCVaccine) {
        self.version = version
        self.dateOfBirth = dateOfBirth
        self.name = name
        self.vaccines = [vaccine]
        self.tests = nil
        self.recoveries = nil
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
    
    init(firstName: String, lastName: String) {
        self.lastNameStandardised = lastName
        self.firstName = firstName
        self.lastName = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "fn"
        case lastName = "gn"
        case lastNameStandardised = "gnt"
    }
}

struct DCCVaccine: Codable {
    let targetedDisease: String
    let vaccine: String
    let vaccineMedicalProduct: String // EU1/20/1507 (vaccine model?)
    let marketingAuthorizationHolder: String // ORG-100031184 issuer?
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
    
    func getVaccinationAge() -> DateComponents? {
        guard let date = getDateOfVaccination() else { return nil }
        return Calendar.current.dateComponents([.day, .hour], from: date, to: Date())
    }
    
    func isFullyVaccinated() -> Bool {
        return doseNumber >= totalSeriesOfDoses
    }
    
    func isCountryValid() -> Bool {
        return IsoCountries.countryForCode(code: countryOfVaccination) != nil
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
    
    let targetedDisease: String
    let typeOfTest: String
    let NAATestName: String?
    let RATTestNameAndManufac: String?
    let dateOfSampleCollection: String
    let testResult: String
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
    
    func isCountryValid() -> Bool {
        return IsoCountries.countryForCode(code: countryOfTest) != nil
    }
    
    func getTestAgeInHours(toDate: Date) -> Int? {
        guard let dateOfTest = getDateOfTest() else { return nil }
        let difference = Calendar.current.dateComponents([.hour, .minute], from: dateOfTest, to: toDate)
        var hours = difference.hour ?? 0
        if (difference.minute ?? 0) > 0 {
            hours += 1
        }
        return hours
    }
    
    func getTestIssues(from: CountryColorCode, to: String) -> DCCFailableItem? {
        if let type = getTestType, let hoursDifference = getTestAgeInHours(toDate: Date()) {
            if let maxHours = type.validFor(country: to) {
                if hoursDifference > maxHours {
                    return .testDateExpired(hours: hoursDifference)
                }
            }
        } else {
            return .invalidTestDate
        }
        return nil
    }
    
    func getAgeString() -> String {
        guard let date = getDateOfTest() else { return "item_unknown".localized() }
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: Date())
        let hours = diffComponents.hour ?? 0
        let minutes = diffComponents.minute ?? 0
        return "test_ago_x".localized(params: hours, minutes)
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
    
    let targetedDisease: String
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
    
    func getRecoveryAge() -> DateComponents? {
        guard let date = getDateOfFirstPositiveTest() else { return nil }
        return Calendar.current.dateComponents([.day, .hour], from: date, to: Date())
    }
    
    func isValidRecovery(date: Date) -> Bool {
        guard let from = getDateValidFrom(), let to = getDateValidTo() else { return false }
        let nowTime = date.timeIntervalSince1970
        return nowTime >= from.timeIntervalSince1970 && nowTime <= to.timeIntervalSince1970
    }
    
    func isCountryValid() -> Bool {
        return IsoCountries.countryForCode(code: countryOfTest) != nil
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
