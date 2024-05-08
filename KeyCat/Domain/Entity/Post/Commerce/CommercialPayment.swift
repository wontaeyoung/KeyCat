//
//  CommercialPayment.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import Foundation

struct CommercialPayment: Entity {
  
  let paymentID: String
  let buyerID: String
  let postID: String
  let merchantUID: String
  let productName: String
  let price: Int
  let paidAt: Date
}
