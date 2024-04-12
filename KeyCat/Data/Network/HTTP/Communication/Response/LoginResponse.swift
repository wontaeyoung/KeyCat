//
//  LoginResponse.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

/// 로그인
struct LoginResponse: HTTPResponse {
  let user_id: String
  let email: String
  let nick: String
  let profileImage: String?
  let accessToken: String
  let refreshToken: String
}
