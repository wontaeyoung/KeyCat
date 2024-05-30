//
//  ChatRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/23/24.
//

import Foundation
import RxSwift

final class ChatRepositoryImpl: ChatRepository, HTTPErrorTransformer {
  
  private let apiService: APIService
  private let chatMapper: ChatMapper
  
  init(
    service: APIService = APIService(),
    chatMapper: ChatMapper = ChatMapper()
  ) {
    self.apiService = service
    self.chatMapper = chatMapper
  }
  
  func createChatRoom(otherUserID: ChatRoom.UserID) -> Single<ChatRoom> {
    
    let request = CreateChatRoomRequest(opponent_id: otherUserID)
    let router = ChatRouter.roomCreate(request: request)
    
    return apiService.callRequest(with: router, of: ChatRoomDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .createChatRoom)
        return .error(domainError)
      }
      .map { self.chatMapper.toEntity($0) }
  }
  
  func fetchMyChatRooms() -> Single<[ChatRoom]> {
    
    let router = ChatRouter.myChatRoomsFetch
    
    return apiService.callRequest(with: router, of: FetchChatRoomsResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchMyChatRooms)
        return .error(domainError)
      }
      .map { self.chatMapper.toEntity($0.data) }
  }
  
  func fetchChats(roomID: ChatRoom.RoomID, cursor date: Date) -> Single<[Chat]> {
    
    let query = FetchChatsQuery(cursor_date: date.toISOString)
    let router = ChatRouter.chatsFetch(roomID: roomID, query: query)
    
    return apiService.callRequest(with: router, of: FetchChatsResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchChats)
        return .error(domainError)
      }
      .map { self.chatMapper.toEntity($0.data) }
  }
  
  func sendChat(chat: Chat) -> Single<Chat> {
    
    let request = chatMapper.toRequest(chat)
    let router = ChatRouter.chatSend(roomID: chat.roomID, request: request)
    
    return apiService.callRequest(with: router, of: ChatDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .sendChat)
        return .error(domainError)
      }
      .map { self.chatMapper.toEntity($0) }
  }
  
  func uploadChatImages(roomID: ChatRoom.RoomID, files: [Data]) -> Single<[Chat.URLString]> {
    
    return apiService.callChatImageUploadRequest(roomID: roomID, data: files)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .uploadChatImages)
        return .error(domainError)
      }
      .map { $0.files }
  }
}
