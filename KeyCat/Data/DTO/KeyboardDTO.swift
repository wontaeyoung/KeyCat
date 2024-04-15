//
//  KeyboardDTO.swift
//  KeyCat
//
//  Created by 원태영 on 4/15/24.
//

struct KeyboardDTO: DTO, Encodable {
  
  let keyboardInfo: [Int]
  let keycapInfo: [Int]
  let appearanceInfo: [Int]
}
