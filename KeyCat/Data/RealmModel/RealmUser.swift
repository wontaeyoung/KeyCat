//
//  RealmUser.swift
//  KeyCat
//
//  Created by 원태영 on 5/30/24.
//

import KazRealm
import RealmSwift

final class RealmUser: EmbeddedObject, EmbeddedRealmModel {
  
  enum Column: String {
    
    case userID
    case nickname
    case profileImageURLString
  }
  
  @Persisted(primaryKey: true) var userID: String
  @Persisted var nickname: String
  @Persisted var profileImageURLString: String
  
  convenience init(userID: String, nickname: String, profileImageURLString: String) {
    self.init()
    
    self.userID = userID
    self.nickname = nickname
    self.profileImageURLString = profileImageURLString
  }
}
