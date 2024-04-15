//
//  UserMapper.swift
//  KeyCat
//
//  Created by 원태영 on 4/15/24.
//

struct UserMapper {
  
  func toEntity(_ dto: UserDTO) -> User {
    return User(
      userID: dto.user_id,
      nickname: dto.nick,
      profileImageURLString: dto.profileImage
    )
  }
}
