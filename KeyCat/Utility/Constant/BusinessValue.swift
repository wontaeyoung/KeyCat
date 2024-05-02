//
//  BusinessValue.swift
//  KeyCat
//
//  Created by 원태영 on 4/15/24.
//

enum BusinessValue {
  
  static let maxImageFileVolumeMB: Double = 2.0
  
  enum Product {
    static let maxContentLength: Int = 300
    static let maxProductImage: Int = 5
    static let defaultDeliveryCharge: Int = 3000
    static let maxDiscountExpiryMonthFromNow: Int = 1
    static let specialPriceRatio: Int = 75
  }
  
  enum OptionLength {
    
    static let keyboardInfo: Int = 8
    static let keycapInfo: Int = 4
    static let keyboardAppearance: Int = 7
    static let commercialPrice: Int = 4
    static let deliveryInfo: Int = 2
  }
}
