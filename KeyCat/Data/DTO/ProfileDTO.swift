//
//  ProfileDTO.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

/// 내 프로필
/// 다른 유저 프로필
struct ProfileDTO: DTO {
  
  let user_id: String
  let email: String
  let nick: String
  let phoneNum: String
  let birthDay: String
  let profileImage: String
  let followers: [UserDTO]
  let following: [UserDTO]
  let posts: [String]
  
  enum CodingKeys: CodingKey {
    case user_id
    case email
    case nick
    case phoneNum
    case birthDay
    case profileImage
    case followers
    case following
    case posts
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.user_id = try container.decode(String.self, forKey: .user_id)
    self.email = try container.decodeWithDefaultValue(String.self, forKey: .email)
    self.nick = try container.decode(String.self, forKey: .nick)
    self.phoneNum = try container.decodeWithDefaultValue(String.self, forKey: .phoneNum)
    self.birthDay = try container.decodeWithDefaultValue(String.self, forKey: .birthDay)
    self.profileImage = try container.decodeWithDefaultValue(String.self, forKey: .profileImage)
    self.followers = try container.decode([UserDTO].self, forKey: .followers)
    self.following = try container.decode([UserDTO].self, forKey: .following)
    self.posts = try container.decode([String].self, forKey: .posts)
  }
}
