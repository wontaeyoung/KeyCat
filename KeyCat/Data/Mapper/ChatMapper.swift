//
//  ChatMapper.swift
//  KeyCat
//
//  Created by 원태영 on 5/23/24.
//

struct ChatMapper: Mapper {
  
  private let userMapper = UserMapper()
  
  func toEntity(_ dto: ChatDTO?) -> Chat? {
    
    guard let dto else { return nil }
    
    return Chat(
      chatID: dto.chat_id,
      roomID: dto.room_id,
      content: dto.content,
      createdAt: toDate(from: dto.createdAt),
      sender: userMapper.toEntity(dto.sender),
      images: dto.files,
      senderType: dto.sender.user_id == UserInfoService.userID ? .me : .other
    )
  }
  
  func toEntity(_ dto: ChatDTO) -> Chat {
    
    return Chat(
      chatID: dto.chat_id,
      roomID: dto.room_id,
      content: dto.content,
      createdAt: toDate(from: dto.createdAt),
      sender: userMapper.toEntity(dto.sender),
      images: dto.files,
      senderType: dto.sender.user_id == UserInfoService.userID ? .me : .other
    )
  }
  
  func toEntity(_ dtos: [ChatDTO]) -> [Chat] {
    
    return dtos.map { toEntity($0) }
  }
  
  func toEntity(_ dto: ChatRoomDTO) -> ChatRoom {
    
    return ChatRoom(
      roomID: dto.room_id,
      createdAt: toDate(from: dto.createdAt),
      updatedAt: toDate(from: dto.updatedAt),
      joins: userMapper.toEntity(dto.participants),
      lastChat: toEntity(dto.lastChat)
    )
  }
  
  func toEntity(_ dtos: [ChatRoomDTO]) -> [ChatRoom] {
    
    return dtos.map { toEntity($0) }
  }
}
