//
//  FollowDTO.swift
//  KeyCat
//
//  Created by 원태영 on 4/12/24.
//

struct FollowDTO: DTO {
  let nick: String
  let opponent_nick: String
  let following_status: Bool
  
  static var defaultValue: FollowDTO {
    return FollowDTO(
      nick: .defaultValue,
      opponent_nick: .defaultValue, 
      following_status: .defaultValue
    )
  }
}
