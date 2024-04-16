//
//  AuthRouter.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Foundation
import Alamofire

enum AuthRouter: Router {
  
  case join(request: JoinRequest)
  case login(request: LoginRequest)
  
  var method: HTTPMethod {
    switch self {
      case .join, .login:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case .join:
        return "/users/join"
      case .login:
        return "/users/login"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .join, .login:
        return [
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .join, .login:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .join(let request):
        return requestToBody(request)
      case .login(let request):
        return requestToBody(request)
    }
  }
}
