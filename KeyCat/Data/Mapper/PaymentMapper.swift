//
//  PaymentMapper.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

struct PaymentMapper: Mapper {
  
  func toEntity(_ dto: PaymentDTO) -> CommercialPayment {
    
    return CommercialPayment(
      paymentID: dto.payment_id,
      buyerID: dto.buyer_id, 
      postID: dto.post_id,
      merchantUID: dto.merchant_uid,
      productName: dto.productName,
      price: dto.price, 
      paidAt: toDate(from: dto.paidAt)
    )
  } 
}
