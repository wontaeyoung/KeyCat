//
//  ChatRepository.swift
//  KeyCat
//
//  Created by 원태영 on 5/24/24.
//

import Foundation
import RxSwift

protocol ChatRepository {
  
  func createChatRoom(otherUserID: ChatRoom.UserID) -> Single<ChatRoom>
  func fetchMyChatRooms() -> Single<[ChatRoom]>
  func fetchChats(roomID: ChatRoom.RoomID, cursor date: Date) -> Single<[Chat]>
}
