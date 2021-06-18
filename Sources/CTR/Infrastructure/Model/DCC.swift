//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

struct DCCQR: Codable {
   
    let credentialVersion: Int? // Version of this QR
    private let issuer: String? // Country for example France
    let issuedAt: TimeInterval? // When was this QR issued at in seconds
    let expirationTime: TimeInterval? // When does this QR expire in seconds
    
    let dcc: DCC?
    
    var getIssuer: Country? {
        guard let issuer = issuer else { return nil }
        return Country(rawValue: issuer)
    }
    
    func getName() -> String {
        return "\((dcc?.name?.lastName ?? "").capitalized) \((dcc?.name?.firstName ?? "").capitalized) "
    }
    
    func getBirthDate() -> String {
        return dcc?.dateOfBirth ?? ""
    }
    
    var isSpecimen: Bool {
        return false
    }
    
    var isDomesticDcc: Bool {
        return false
    }
    
    var isVerified: Bool {
        return expirationTime ?? 0 > Date().timeIntervalSince1970
    }
}

struct DCC: Codable {
    /// DCC version
    let version: String?
    /// Date of birth 1962-07-01
    let dateOfBirth: String?
    /// Name object
    let name: DCCNameObject?
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
}

struct DCCNameObject: Codable {
    /// First name
    let firstName: String?
    /// Last name
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "fn"
        case lastName = "gn"
    }
}

struct DCCVaccine: Codable {
    private let targetedDisease: String?
    private let vaccine: String?
    private let vaccineMedicalProduct: String? // EU1/20/1507 (vaccine model?)
    private let marketingAuthorizationHolder: String? // ORG-100031184 issuer?
    let doseNumber: Int?
    let totalSeriesOfDoses: Int?
    let dateOfVaccination: String? // Date
    private let countryOfVaccination: String? // Country Code
    let certificateIssuer: String? //
    let certificateIdentifier: String? //
    
    var getVaccine: VaccineProphylaxis? {
        guard let vaccine = vaccine else { return nil }
        return VaccineProphylaxis(rawValue: vaccine)
    }
    
    var getVaccineProduct: VaccineProduct? {
        guard let product = vaccineMedicalProduct else { return nil }
        return VaccineProduct(rawValue: product)
    }
    
    var getTargetedDisease: TargetedDisease? {
        guard let targetedDisease = targetedDisease else { return nil }
        return TargetedDisease(rawValue: targetedDisease)
    }
    
    var getCountryOfVaccination: Country? {
        guard let countryOfVaccination = countryOfVaccination else { return nil }
        return Country(rawValue: countryOfVaccination)
    }
    
    var getMarketingHolder: VaccineHolder? {
        guard let holder = marketingAuthorizationHolder else { return nil }
        return VaccineHolder(rawValue: holder)
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
    
    private let targetedDisease: String?
    private let typeOfTest: String?
    let NAATestName: String?
    let RATTestNameAndManufac: String?
    let dateOfSampleCollection: String?
    let testResult: String?
    let testingCentre: String?
    private let countryOfTest: String?
    let certificateIssuer: String?
    let certificateIdentifier: String?
    
    var getCountryOfTest: Country? {
        guard let countryOfTest = countryOfTest else { return nil }
        return Country(rawValue: countryOfTest)
    }
    
    var getTargetedDisease: TargetedDisease? {
        guard let targetedDisease = targetedDisease else { return nil }
        return TargetedDisease(rawValue: targetedDisease)
    }
    
    var getTestType: DCCTestType? {
        guard let typeOfTest = typeOfTest else { return nil }
        return DCCTestType(rawValue: typeOfTest)
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
    
    private let targetedDisease: String?
    let dateOfFirstPositiveTest: String?
    private let countryOfTest: String?
    let certificateIssuer: String?
    let certificateValidFrom: String?
    let certificateValidTo: String?
    let certificateIdentifier: String?
    
    var getTargetedDisease: TargetedDisease? {
        guard let targetedDisease = targetedDisease else { return nil }
        return TargetedDisease(rawValue: targetedDisease)
    }
    
    var getCountryOfTest: Country? {
        guard let countryOfTest = countryOfTest else { return nil }
        return Country(rawValue: countryOfTest)
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



