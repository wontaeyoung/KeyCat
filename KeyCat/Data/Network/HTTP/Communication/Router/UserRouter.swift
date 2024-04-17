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
  
  var method: HTTPMethod {
    switch self {
      case .follow:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case .follow(let userID):
        return "/follow/\(userID)"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .follow:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .follow:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .follow:
        return nil
    }
  }
}
