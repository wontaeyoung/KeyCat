//
//  NumberFormatManager.swift
//  KeyCat
//
//  Created by 원태영 on 4/24/24.
//

import Foundation

final class NumberFormatManager {
  
  enum Unit: String {
    case km
    case MB
  }
  
  static let shared = NumberFormatManager()
  private init() { configFormatter() }
  
  // MARK: - Property
  private let formatter = NumberFormatter()

  // MARK: - Method
  private func configFormatter() {
    formatter.numberStyle = .decimal
    formatter.roundingMode = .halfUp
  }
  
  func toCurrency(from number: Int) -> String {
    return formatter.string(from: number as NSNumber) ?? String(number)
  }
  
  func toRounded(from number: Double, fractionDigits: Int) -> String {
    formatter.maximumFractionDigits = fractionDigits
    return formatter.string(from: number as NSNumber) ?? String(number)
  }
  
  func toRoundedWith(from number: Double, fractionDigits: Int, unit: Unit) -> String {
    formatter.maximumFractionDigits = fractionDigits
    let string = formatter.string(from: number as NSNumber) ?? String(number)
    
    return string + " " + unit.rawValue
  }
}
