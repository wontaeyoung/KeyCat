//
//  ChatRoom.swift
//  KeyCat
//
//  Created by 원태영 on 5/23/24.
//

import Foundation

struct ChatRoom: Entity {
  
  let roomID: RoomID
  let createdAt: Date
  let updatedAt: Date
  let joins: [User]
  let lastChat: Chat
}
