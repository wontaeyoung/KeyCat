//
//  BusinessInfoRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/23/24.
//

/// 사업자 번호 조회
struct BusinessInfoRequest: HTTPRequestBody {
  let b_no: [String]
  
  init(b_no: String) {
    self.b_no = [b_no]
  }
}
