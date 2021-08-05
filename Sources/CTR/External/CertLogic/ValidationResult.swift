//
//  ValidationResult.swift
//
//
//  Created by Alexandr Chernyy on 08.06.2021.
//
import Foundation

// MARK: Result type

public enum CertLogicResult: Int {
  case fail = 0
  case passed
  case open
}

// MARK: ValidationResult

public class ValidationResult {
  
  public var rule: Rule?
  public var result: CertLogicResult = .open
  public var validationErrors: [Error]?
  
  public init(rule: Rule?,
              result: CertLogicResult = .open,
              validationErrors: [Error]? = nil) {
    self.rule = rule
    self.result = result
    self.validationErrors = validationErrors
  }
}
