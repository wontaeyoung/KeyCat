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
  var followers: [User]
  var following: [User]
  var postIDs: [PostID]
  let profileType: ProfileType
  
  var profileImageURL: URL? {
    return URL(string: profileImageURLString)
  }
  
  var isFollowing: Bool {
    return followers
      .map { $0.userID }
      .contains(UserInfoService.userID)
  }
  
  static var empty: Profile {
    return Profile(
      userID: .defaultValue,
      email: .defaultValue,
      nickname: .defaultValue,
      userType: .none,
      profileImageURLString: .defaultValue,
      followers: [],
      following: [],
      postIDs: [],
      profileType: .mine
    )
  }
  
  enum UserType: Int, SelectionExpressible {
    
    case none
    case standard
    case seller
    
    var userForOtherProfile: UserType {
      return .none
    }
    
    static let coalesce: Profile.UserType = .none
    
    var name: String {
      switch self {
        case .none: "확인불가"
        case .standard: "일반"
        case .seller: "판매자"
      }
    }
    
    static var title: String {
      return "사용자 유형"
    }
  }
  
  enum ProfileType {
    case mine
    case other
  }
}
