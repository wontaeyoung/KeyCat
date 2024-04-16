//
//  AuthRouter.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Foundation
import Alamofire

enum AuthRouter: Router {
  
  case login(request: LoginRequest)
  
  var method: HTTPMethod {
    switch self {
      case .login:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case .login:
        return "/users/login"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .login:
        return [
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .login:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .login(let request):
        return try? JsonCoder.shared.encode(from: request)
    }
  }
}
