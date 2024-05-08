//
//  PaymentValidationRequest.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import Foundation

struct PaymentValidationRequest: HTTPRequestBody {
  
  let imp_uid: String
  let post_id: String
  let productName: String
  let price: Int
}
