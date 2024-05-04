//
//  Review.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

import Foundation

struct CommercialReview: Entity {
  
  let reviewID: String
  let content: String
  let rating: Rating
  let createdAt: Date
  let creator: User
  
  var dateString: String {
    if DateManager.shared.isToday(createdAt) { return "오늘" }
    if DateManager.shared.isYesterday(createdAt) { return "어제" }
    
    return DateManager.shared.toString(with: createdAt, format: .yyyyMMddEEDot)
  }
  
  var isCreatedByMe: Bool {
    return creator.userID == UserInfoService.userID
  }
  
  enum Rating: Int, CaseIterable {
    case one = 1
    case two
    case three
    case four
    case five
    
    static let coalesce: Rating = .one
    
    var value: Int {
      return self.rawValue
    }
    
    init(_ rawValue: Int) {
      self = Rating(rawValue: rawValue) ?? Self.coalesce
    }
  }
}
