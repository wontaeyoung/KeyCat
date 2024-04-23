//
//  BusinessInfo.swift
//  KeyCat
//
//  Created by 원태영 on 4/23/24.
//

struct BusinessInfo: Entity {
  
  let businessNumber: String
  let businessStatus: BusinessStatus
  
  enum BusinessStatus: String {
    case active = "01"
    case suspended = "02"
    case closed = "03"
    case unregistered
    
    init(_ rawValue: String) {
      self = BusinessStatus(rawValue: rawValue) ?? .unregistered
    }
  }
}
