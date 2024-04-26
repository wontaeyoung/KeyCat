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
    
    var statusMessage: String {
      switch self {
        case .active: "사업자 등록이 확인되었어요."
        case .suspended: "휴업 상태의 사업자는 판매자 등록이 불가능해요."
        case .closed: "폐업 상태의 사업자는 판매자 등록이 불가능해요."
        case .unregistered: "등록 정보를 확인할 수 없어요."
      }
    }
  }
  
  static var unregistered: BusinessInfo {
    return BusinessInfo(
      businessNumber: "-",
      businessStatus: .unregistered
    )
  }
}
