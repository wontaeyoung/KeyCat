//
//  Profile.swift
//  KeyCat
//
//  Created by 원태영 on 4/14/24.
//

import Foundation

struct Profile: Entity {
  
  let userID: UserID
  let email: String
  let nickname: String
  let userType: UserType
  let profileImageURLString: URLString
  let followers: [User]
  let folllowing: [User]
  let postIDs: [PostID]
  let profileType: ProfileType
  
  var profileImageURL: URL? {
    return URL(string: profileImageURLString)
  }
  
  enum UserType: Int {
    case none
    case standard
    case seller
    
    var userForOtherProfile: UserType {
      return .none
    }
  }
  
  enum ProfileType {
    case mine
    case other
  }
}

