//
//  AuthResponse.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

/// 회원가입
/// 회원탈퇴
struct AuthResponse: HTTPResponse {
  let user_id: String
  let email: String
  let nick: String
}
