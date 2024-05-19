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
