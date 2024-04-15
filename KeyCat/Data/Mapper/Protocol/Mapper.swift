//
//  Mapper.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

import Foundation

protocol Mapper {
  
  func toDate(from isoDateString: String) -> Date
}

extension Mapper {
  
  func toDate(from isoDateString: String) -> Date {
    return DateManager.shared.isoStringtoDate(with: isoDateString)
  }
}
