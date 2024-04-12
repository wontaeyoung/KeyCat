//
//  JoinRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

/// 회원가입 요청
struct JoinRequest: HTTPRequestBody {
  let email: String
  let password: String
  let nick: String
  let phoneNum: String?
  let birthDay: String?
}
