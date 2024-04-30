//
//  DeliveryInfo.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

struct DeliveryInfo {
  
  let price: Price
  let schedule: Schedule
  
  var raws: [Int] {
    return [
      price.rawValue,
      schedule.rawValue
    ]
  }
  
  enum Price: Int, SelectionExpressible {
    case paid
    case free
    
    static let coalesce: Price = .paid
    
    static var title: String {
      return "배송비"
    }
    
    var name: String {
      switch self {
        case .paid: "\(BusinessValue.Product.deliveryCharge.formatted())원"
        case .free: "무료배송"
      }
    }
  }
  
  enum Schedule: Int, SelectionExpressible {
    case standard
    case today
    case nextDawn
    case nextDay
    
    static let coalesce: Schedule = .standard
    
    static var title: String {
      return "도착 예정"
    }
    
    var name: String {
      switch self {
        case .standard: "일반"
        case .today: "오늘 도착"
        case .nextDawn: "내일 새벽 도착"
        case .nextDay: "내일 도착"
      }
    }
  }
}
