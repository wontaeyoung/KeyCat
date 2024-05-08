//
//  PaymentDTO.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

struct PaymentDTO: DTO {
  
  let payment_id: String
  let buyer_id: String
  let post_id: String
  let merchant_uid: String
  let productName: String
  let price: Int
  let paidAt: String
}
