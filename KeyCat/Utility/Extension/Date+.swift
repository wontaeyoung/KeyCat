//
//  Date+.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import Foundation

extension Date {
  var toISOString: String {
    return DateManager.shared.dateToIsoString(with: self)
  }
}
