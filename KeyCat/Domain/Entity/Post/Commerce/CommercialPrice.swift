//
//  CommercialPrice.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

import Foundation

struct CommercialPrice {
  
  let regularPrice: Int
  let couponPrice: Int
  let discountPrice: Int
  let discountExpiryDate: Date?
  
  var discountRatio: Int {
    guard regularPrice > 0 else { return 0 }
    return Int(
      ((Double(regularPrice) - Double(discountPrice)) / Double(regularPrice) * 100).rounded(.down)
    )
  }
}
