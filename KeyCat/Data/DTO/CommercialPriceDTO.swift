//
//  CommercialPriceDTO.swift
//  KeyCat
//
//  Created by 원태영 on 4/15/24.
//

struct CommercialPriceDTO: DTO, Encodable {
  
  let regularPrice: Int
  let couponPrice: Int
  let discountPrice: Int
  let discountExpiryDate: String
}
