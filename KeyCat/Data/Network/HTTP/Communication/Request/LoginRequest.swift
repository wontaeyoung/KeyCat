//
//  LoginRequest.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

struct LoginRequest: HTTPRequestBody {
  let email: String
  let password: String
}
