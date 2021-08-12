//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import Foundation

enum VaccineHolder: String {
    
    case astraZeneca = "ORG-100001699"
    case bioNTech = "ORG-100030215"
    case janssen = "ORG-100001417"
    case moderna = "ORG-100031184"
    case cureVac = "ORG-100006270"
    case cansino = "ORG-100013793"
    case chinaSinopharm = "ORG-100020693"
    case europeSinopharm = "ORG-100010771"
    case zhijunSinopharm = "ORG-100024420"
    case novavax = "ORG-100032020"
    case gamaleya = "Gamaleya-Research-Institute"
    case vector = "Vector-Institute"
    case sinoVac = "Sinovac-Biotech"
    case bharat = "Bharat-Biotech"
    case serumInstituteIndia = "ORG-100001981"
    
    var displayName: String {
        switch self {
        
            case .astraZeneca:
                return "AstraZeneca AB"
            case .bioNTech:
                return "Biontech Manufacturing GmbH"
            case .janssen:
                return "Janssen-Cilag International"
            case .moderna:
                return "Moderna Biotech Spain S.L."
            case .cureVac:
                return "Curevac AG"
            case .cansino:
                return "CanSino Biologics"
            case .chinaSinopharm:
                return "China Sinopharm International Corp. - Beijing locatie"
            case .europeSinopharm:
                return "Sinopharm Weiqida Europe Pharmaceutical s.r.o. - Praag locatie"
            case .zhijunSinopharm:
                return "Sinopharm Zhijun (Shenzhen) Pharmaceutical Co. Ltd. - Shenzhen locatie"
            case .novavax:
                return "Novavax CZ AS"
            case .gamaleya:
                return "Gamaleya Research Institute"
            case .vector:
                return "Vector Institute"
            case .sinoVac:
                return "Sinovac Biotech"
            case .bharat:
                return "Bharat Biotech"
            case .serumInstituteIndia:
                return "Serum Institute Of India Private Limited"
        }
    }
    
}
