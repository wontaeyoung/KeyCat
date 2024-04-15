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
  
  enum Rating: Int, CaseIterable {
    case one = 1
    case two
    case three
    case four
    case five
    
    var value: Int {
      return self.rawValue
    }
    
    init(_ rawValue: Int) {
      self = Rating(rawValue: rawValue) ?? .one
    }
  }
}

