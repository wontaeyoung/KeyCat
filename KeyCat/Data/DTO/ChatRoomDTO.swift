//
//  ChatRoomDTO.swift
//  KeyCat
//
//  Created by 원태영 on 5/19/24.
//

struct ChatRoomDTO: DTO {
  
  let room_id: String
  let createdAt: String
  let updatedAt: String
  let participants: [UserDTO]
  let lastChat: ChatDTO?
  let files: [String]
  
  enum CodingKeys: CodingKey {
    case room_id
    case createdAt
    case updatedAt
    case participants
    case lastChat
    case files
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.room_id = try container.decode(String.self, forKey: .room_id)
    self.createdAt = try container.decode(String.self, forKey: .createdAt)
    self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
    self.participants = try container.decode([UserDTO].self, forKey: .participants)
    self.lastChat = try container.decodeIfPresent(ChatDTO.self, forKey: .lastChat)
    self.files = try container.decodeWithDefaultValue([String].self, forKey: .files)
  }
  
  init(
    room_id: String,
    createdAt: String,
    updatedAt: String,
    participants: [UserDTO],
    lastChat: ChatDTO?,
    files: [String]
  ) {
    self.room_id = room_id
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.participants = participants
    self.lastChat = lastChat
    self.files = files
  }
}
