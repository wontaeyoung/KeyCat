//
//  FetchPaymentResponse.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

struct FetchPaymentsResponse: HTTPResponse {
  let data: [PaymentDTO]
}
