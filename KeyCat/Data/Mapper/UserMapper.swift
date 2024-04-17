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
  
  func toEntity(_ dtos: [UserDTO]) -> [User] {
    return dtos.map { toEntity($0) }
  }
  
  func toEntity(_ dto: ProfileDTO) -> Profile {
    return Profile(
      userID: dto.user_id,
      email: dto.email,
      nickname: dto.nick, 
      userType: getUsetType(userTypeID: dto.phoneNum),
      profileImageURLString: dto.profileImage,
      followers: toEntity(dto.followers),
      folllowing: toEntity(dto.following),
      postIDs: dto.posts,
      profileType: getProfileType(email: dto.email)
    )
  }
  
  func toEntity(_ dto: FollowDTO) -> Follow {
    return Follow(
      myNickname: dto.nick,
      followingNickname: dto.opponent_nick,
      isFollowing: dto.following_status
    )
  }
  
  private func getUsetType(userTypeID: String) -> Profile.UserType {
    guard let id = Int(userTypeID) else {
      return .none
    }
    
    return .init(id)
  }
  
  private func getProfileType(email: String) -> Profile.ProfileType {
    return email.isEmpty ? .other : .mine
  }
}
