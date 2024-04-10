//
//  LogManager.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

import Foundation
import os

@available(iOS 14.0, *)
final class LogManager {
  
  enum LogCategory: String {
    case network = "Network"
    case local = "Local"
    
    static let bundleID: String = Bundle.main.bundleIdentifier ?? ""
    
    var category: String {
      return self.rawValue
    }
  }
  
  // MARK: - Singleton
  static let shared = LogManager()
  private init() { }
  
  
  // MARK: - Property
  private lazy var networkLogger = Logger(subsystem: LogCategory.bundleID, category: LogCategory.network.category)
  private lazy var localLogger = Logger(subsystem: LogCategory.bundleID, category: LogCategory.local.category)
  
  func log(with error: Error, to logTarget: LogCategory, level: OSLogType = .error) {
    guard let error = error as? AppError else {
      let unknownError = CommonError.unknownError(error: error)
      return log(with: unknownError, to: .local)
    }
    
    let message = error.logDescription
        
    switch logTarget {
      case .network:
        networkLogger.log(level: level, "\(message)")
        
      case .local:
        localLogger.log(level: level, "\(message)")
    }
  }
  
  func log(with message: String, to logTarget: LogCategory, level: OSLogType) {
    switch logTarget {
      case .network:
        networkLogger.log(level: level, "\(message)")
        
      case .local:
        localLogger.log(level: level, "\(message)")
    }
  }
}
