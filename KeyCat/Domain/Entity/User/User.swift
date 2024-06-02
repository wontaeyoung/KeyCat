//
//  User.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

import Foundation

struct User: Entity, Hashable {
  
  let userID: UserID
  let nickname: String
  let profileImageURLString: URLString
  
  var profileImageURL: URL? {
    return URL(string: profileImageURLString)
  }
  
  static var empty: User {
    return User(
      userID: .defaultValue,
      nickname: .defaultValue,
      profileImageURLString: .defaultValue
    )
  }
}
