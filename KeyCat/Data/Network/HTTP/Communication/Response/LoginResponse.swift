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
  let profileImage: String
  let accessToken: String
  let refreshToken: String
  
  enum CodingKeys: CodingKey {
    case user_id
    case email
    case nick
    case profileImage
    case accessToken
    case refreshToken
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.user_id = try container.decode(String.self, forKey: .user_id)
    self.email = try container.decode(String.self, forKey: .email)
    self.nick = try container.decode(String.self, forKey: .nick)
    self.profileImage = try container.decodeWithDefaultValue(String.self, forKey: .profileImage)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
  }
}
