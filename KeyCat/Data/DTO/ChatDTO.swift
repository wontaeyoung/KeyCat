//
//  ChatDTO.swift
//  KeyCat
//
//  Created by 원태영 on 5/19/24.
//

struct ChatDTO: DTO, DefaultValueProvidable {
  
  let chat_id: String
  let room_id: String
  let content: String
  let createdAt: String
  let sender: UserDTO
  let files: [String]
  
  enum CodingKeys: CodingKey {
    case chat_id
    case room_id
    case content
    case createdAt
    case sender
    case files
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.chat_id = try container.decode(String.self, forKey: .chat_id)
    self.room_id = try container.decode(String.self, forKey: .room_id)
    self.content = try container.decodeWithDefaultValue(String.self, forKey: .content)
    self.createdAt = try container.decode(String.self, forKey: .createdAt)
    self.sender = try container.decode(UserDTO.self, forKey: .sender)
    self.files = try container.decode([String].self, forKey: .files)
  }
  
  init(
    chat_id: String,
    room_id: String,
    content: String,
    createdAt: String,
    sender: UserDTO,
    files: [String]
  ) {
    self.chat_id = chat_id
    self.room_id = room_id
    self.content = content
    self.createdAt = createdAt
    self.sender = sender
    self.files = files
  }
  
  static var defaultValue: ChatDTO {
    return ChatDTO(
      chat_id: .defaultValue,
      room_id: .defaultValue,
      content: .defaultValue,
      createdAt: .defaultValue,
      sender: .defaultValue,
      files: .defaultValue
    )
  }
}
