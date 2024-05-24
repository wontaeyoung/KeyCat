//
//  ChatRoomUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/24/24.
//

import RxSwift

final class ChatRoomUsecaseImpl: ChatRoomUsecase {
  
  private let chatRepository: ChatRepository
  
  init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
    self.chatRepository = chatRepository
  }
  
  func createChatRoom(otherUserID: ChatRoom.UserID) -> Single<ChatRoom> {
    
    return chatRepository.createChatRoom(otherUserID: otherUserID)
  }
  
  func fetchMyChatRooms() -> Single<[ChatRoom]> {
    
    return chatRepository.fetchMyChatRooms()
  }
}
