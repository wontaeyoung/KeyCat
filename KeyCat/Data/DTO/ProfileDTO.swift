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
  let email: String?
  let nick: String
  let phoneNum: String?
  let birthDay: String?
  let profileImage: String?
  let followers: [UserDTO]
  let folllowing: [UserDTO]
  let posts: [String]
  
  enum CodingKeys: CodingKey {
    case user_id
    case email
    case nick
    case phoneNum
    case birthDay
    case profileImage
    case followers
    case folllowing
    case posts
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.user_id = try container.decodeWithDefaultValue(String.self, forKey: .user_id)
    self.email = try container.decodeWithDefaultValue(String.self, forKey: .email)
    self.nick = try container.decodeWithDefaultValue(String.self, forKey: .nick)
    self.phoneNum = try container.decodeWithDefaultValue(String.self, forKey: .phoneNum)
    self.birthDay = try container.decodeWithDefaultValue(String.self, forKey: .birthDay)
    self.profileImage = try container.decodeWithDefaultValue(String.self, forKey: .profileImage)
    self.followers = try container.decodeWithDefaultValue([UserDTO].self, forKey: .followers)
    self.folllowing = try container.decodeWithDefaultValue([UserDTO].self, forKey: .folllowing)
    self.posts = try container.decodeWithDefaultValue([String].self, forKey: .posts)
  }
  
  init(user_id: String, email: String?, nick: String, phoneNum: String?, birthDay: String?, profileImage: String?, followers: [UserDTO], folllowing: [UserDTO], posts: [String]) {
    self.user_id = user_id
    self.email = email
    self.nick = nick
    self.phoneNum = phoneNum
    self.birthDay = birthDay
    self.profileImage = profileImage
    self.followers = followers
    self.folllowing = folllowing
    self.posts = posts
  }
  
  static var defaultValue: ProfileDTO {
    return ProfileDTO(
      user_id: .defaultValue,
      email: .defaultValue,
      nick: .defaultValue,
      phoneNum: .defaultValue,
      birthDay: .defaultValue,
      profileImage: .defaultValue,
      followers: .defaultValue,
      folllowing: .defaultValue,
      posts: .defaultValue
    )
  }
}
