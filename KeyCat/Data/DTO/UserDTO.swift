//
//  UserDTO.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

/// 포스트, 코멘트 유저 프로퍼티
struct UserDTO: DTO {
  
  let user_id: String
  let nick: String
  let profileImage: String
  
  enum CodingKeys: CodingKey {
    case user_id
    case nick
    case profileImage
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.user_id = try container.decode(String.self, forKey: .user_id)
    self.nick = try container.decode(String.self, forKey: .nick)
    self.profileImage = try container.decodeWithDefaultValue(String.self, forKey: .profileImage)
  }
}
