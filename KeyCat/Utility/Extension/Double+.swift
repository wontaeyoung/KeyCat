//
//  Double+.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

extension Double {
  
  var rounded: String {
    return NumberFormatManager.shared.toRounded(from: self, fractionDigits: 2)
  }
}
