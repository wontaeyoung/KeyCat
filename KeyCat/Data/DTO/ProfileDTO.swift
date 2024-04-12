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
