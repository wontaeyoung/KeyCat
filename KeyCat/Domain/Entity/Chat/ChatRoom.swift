//
//  ChatRoom.swift
//  KeyCat
//
//  Created by 원태영 on 5/23/24.
//

import Foundation

struct ChatRoom: Entity, Hashable {
  
  let roomID: RoomID
  let createdAt: Date
  let updatedAt: Date
  let joins: [User]
  let lastChat: Chat?
  let images: [URLString]
  
  var otherUser: User {
    return joins
      .filter { $0.userID != UserInfoService.userID }
      .first ?? .empty
  }
}
