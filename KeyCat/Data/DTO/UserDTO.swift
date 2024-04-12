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
  let profileImage: String?
}
