//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 29.06.2021.
//

import Foundation

enum CertLogicError: Error {
    // Throw when an schemeversion not valid
  case openState
    // Throw in all other cases
  case unexpected(code: Int)
}

// swiftlint:disable switch_case_alignment
extension CertLogicError: CustomStringConvertible {
    var description: String {
        switch self {
        case .openState:
            return "recheck_rule".localized()
        case .unexpected(_):
            return "unknown_error".localized()
        }
    }
}

extension CertLogicError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .openState:
            return "recheck_rule".localized()
        case .unexpected(_):
            return "unknown_error".localized()
        }
    }
}
