//
//  ChatRoomUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/24/24.
//

import RxSwift

protocol ChatRoomUsecase {
  
  func createChatRoom(otherUserID: ChatRoom.UserID) -> Single<ChatRoom>
}
