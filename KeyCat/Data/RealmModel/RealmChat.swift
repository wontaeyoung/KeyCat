//
//  RealmChat.swift
//  KeyCat
//
//  Created by 원태영 on 5/30/24.
//

import Foundation
import KazRealm
import RealmSwift

final class RealmChat: Object, RealmModel {
  
  enum Column: String {
    
    case chatID
    case roomID
    case content
    case createdAt
    case sender
    case images
  }
  
  @Persisted(primaryKey: true) var chatID: String
  @Persisted var roomID: String
  @Persisted var content: String
  @Persisted var createdAt: Date
  @Persisted var sender: RealmUser
  @Persisted var images: List<String>
}
