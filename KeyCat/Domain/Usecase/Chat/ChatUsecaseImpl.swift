//
//  ChatUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/25/24.
//

import Foundation
import RxSwift

final class ChatUsecaseImpl: ChatUsecase {
  
  private let chatRepository: ChatRepository
  
  init(chatRepository: ChatRepository = ChatRepositoryImpl()) {
    self.chatRepository = chatRepository
  }
  
  func fetchChats(roomID: ChatRoom.RoomID) -> Single<[Chat]> {
    
    // FIXME: Realm DB 연동 후 커서 날짜 획득 로직 추가 구현 필요
    let date1970 = Date(timeIntervalSince1970: .zero)
    return chatRepository.fetchChats(roomID: roomID, cursor: date1970)
  }
}
