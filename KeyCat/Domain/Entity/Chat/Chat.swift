//
//  Chat.swift
//  KeyCat
//
//  Created by 원태영 on 5/23/24.
//

import Foundation

struct Chat: Entity, Hashable {
  
  let chatID: ChatID
  let roomID: RoomID
  let content: String
  let createdAt: Date
  let sender: User
  var images: [URLString]
  let senderType: SenderType
  
  var mainImageURL: URL? {
    return chatImagesURL
      .compactMap { $0 }
      .first
  }
  
  var chatImagesURL: [URL?] {
    return images.map { URL(string: $0) }
  }
  
  enum SenderType {
    
    case me
    case other
  }
}
