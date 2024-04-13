//
//  User.swift
//  KeyCat
//
//  Created by 원태영 on 4/13/24.
//

import Foundation

struct User: Entity {
  let userID: String
  let nickname: String
  let profileImageURLString: String
  
  var profileImageURL: URL? {
    return URL(string: profileImageURLString)
  }
}
