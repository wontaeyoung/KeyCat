//
//  PostType.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

enum PostType: String {
  
  case keycat_commercialProduct
  case keycat_secondhandTrade
  case keycat_groupBuy
  
  var productID: String {
    return self.rawValue
  }
  
  init(productID: String) {
    self = PostType(rawValue: productID) ?? .keycat_commercialProduct
  }
}
