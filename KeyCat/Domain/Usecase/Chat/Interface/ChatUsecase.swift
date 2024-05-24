//
//  ChatUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/25/24.
//

import RxSwift

protocol ChatUsecase {
  
  func fetchChats(roomID: ChatRoom.RoomID) -> Single<[Chat]>
}
