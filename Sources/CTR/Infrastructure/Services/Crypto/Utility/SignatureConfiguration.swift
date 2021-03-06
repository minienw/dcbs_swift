/*
 * Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

final class SignatureConfiguration {

    static var rootCertificateData: Data? {
        guard let localUrl = Bundle(for: SignatureConfiguration.self).url(forResource: "demo-root" /* "nl-root" */, withExtension: "pem") else {
            return nil
        }
        return try? Data(contentsOf: localUrl)
    }

    static var rootSubjectKeyIdentifier: Data {
        // return Data([0x04, 0x14, /* keyID starts here: */ 0x08, 0x4A, 0xAA, 0xBB, 0x99, 0x24, 0x6F, 0xBE, 0x5B, 0x07, 0xF1, 0xA5, 0x8A, 0x99, 0x5B, 0x2D, 0x47, 0xEF, 0xB9, 0x3C])
        return Data([0x04, 0x14, /* keyID starts here: */ 0xfe, 0xab, 0x00, 0x90, 0x98, 0x9e, 0x24, 0xfc, 0xa9, 0xcc, 0x1a, 0x8a, 0xfb, 0x27, 0xb8, 0xbf, 0x30, 0x6e, 0xa8, 0x3b])
    }

    static var authorityKeyIdentifier: Data {
        // return Data([0x04, 0x14, /* keyID starts here: */ 0xfe, 0xab, 0x00, 0x90, 0x98, 0x9e, 0x24, 0xfc, 0xa9, 0xcc, 0x1a, 0x8a, 0xfb, 0x27, 0xb8, 0xbf, 0x30, 0x6e, 0xa8, 0x3b])
        return Data([0x04, 0x14, /* keyID starts here: */ 0x08, 0x4A, 0xAA, 0xBB, 0x99, 0x24, 0x6F, 0xBE, 0x5B, 0x07, 0xF1, 0xA5, 0x8A, 0x99, 0x5B, 0x2D, 0x47, 0xEF, 0xB9, 0x3C])
        }

    static let commonNameContent = "coronatester.nl"
	
    static let commonNameSuffix = ".nl"

    static var rootSerial: UInt64 {
        return 10000013
    }
}
