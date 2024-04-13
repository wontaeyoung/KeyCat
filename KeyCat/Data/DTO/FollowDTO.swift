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
  
  enum CodingKeys: CodingKey {
    case nick
    case opponent_nick
    case following_status
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.nick = try container.decodeWithDefaultValue(String.self, forKey: .nick)
    self.opponent_nick = try container.decodeWithDefaultValue(String.self, forKey: .opponent_nick)
    self.following_status = try container.decodeWithDefaultValue(Bool.self, forKey: .following_status)
  }
  
  init(nick: String, opponent_nick: String, following_status: Bool) {
    self.nick = nick
    self.opponent_nick = opponent_nick
    self.following_status = following_status
  }
  
  static var defaultValue: FollowDTO {
    return FollowDTO(
      nick: .defaultValue,
      opponent_nick: .defaultValue,
      following_status: .defaultValue
    )
  }
}
