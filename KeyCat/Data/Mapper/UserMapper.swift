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
  
  func toEntity(_ response: AuthResponse) -> User {
    return User(
      userID: response.user_id,
      nickname: response.nick,
      profileImageURLString: .defaultValue
    )
  }
  
  func toEntity(_ response: LoginResponse) -> User {
    return User(
      userID: response.user_id,
      nickname: response.nick,
      profileImageURLString: response.profileImage
    )
  }
  
  func toEntity(_ dtos: [UserDTO]) -> [User] {
    return dtos.map { toEntity($0) }
  }
  
  func toDTO(_ entity: User) -> UserDTO {
    return UserDTO(
      user_id: entity.userID,
      nick: entity.nickname,
      profileImage: entity.profileImageURLString
    )
  }
  
  func toDTO(_ entities: [User]) -> [UserDTO] {
    return entities.map { toDTO($0) }
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
  
  func toEntity(_ dto: BusinessInfoDTO) -> BusinessInfo {
    return BusinessInfo(
      businessNumber: dto.b_no,
      businessStatus: .init(dto.b_stt_cd)
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
