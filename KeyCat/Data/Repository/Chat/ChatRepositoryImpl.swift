//
//  ChatRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/23/24.
//

import Foundation
import RxSwift

final class ChatRepositoryImpl: ChatRepository, HTTPErrorTransformer {
  
  private let service: APIService
  private let chatMapper: ChatMapper
  
  init(
    service: APIService = APIService(),
    chatMapper: ChatMapper = ChatMapper()
  ) {
    self.service = service
    self.chatMapper = chatMapper
  }
  
  func createChatRoom(otherUserID: ChatRoom.UserID) -> Single<ChatRoom> {
    
    let request = CreateChatRoomRequest(opponent_id: otherUserID)
    let router = ChatRouter.roomCreate(request: request)
    
    return service.callRequest(with: router, of: ChatRoomDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .createChatRoom)
        return .error(domainError)
      }
      .map { self.chatMapper.toEntity($0) }
  }
}
