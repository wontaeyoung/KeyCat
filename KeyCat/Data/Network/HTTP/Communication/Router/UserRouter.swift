//
//  UserRouter.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import Foundation
import Alamofire

enum UserRouter: Router {
  
  case follow(userID: Entity.UserID)
  case unfollow(userID: Entity.UserID)
  case myProfileFetch
  
  var method: HTTPMethod {
    switch self {
      case .follow:
        return .post
        
      case .unfollow:
        return .delete
        
      case .myProfileFetch:
        return .get
    }
  }
  
  var path: String {
    switch self {
      case .follow(let userID):
        return "/follow/\(userID)"
        
      case .unfollow(let userID):
        return "/follow/\(userID)"
        
      case .myProfileFetch:
        return "/users/me/profile"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .follow, .unfollow, .myProfileFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .follow, .unfollow, .myProfileFetch:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .follow, .unfollow, .myProfileFetch:
        return nil
    }
  }
}
