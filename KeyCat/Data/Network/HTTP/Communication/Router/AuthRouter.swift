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
  case emailValidation(request: EmailValidationRequest)
  case login(request: LoginRequest)
  case tokenRefresh
  case withdraw
  
  var method: HTTPMethod {
    switch self {
      case .join, .emailValidation, .login:
        return .post
      case .tokenRefresh, .withdraw:
        return .get
    }
  }
  
  var path: String {
    switch self {
      case .join:
        return "/users/join"
      case .emailValidation:
        return "/validation/email"
      case .login:
        return "/users/login"
      case .tokenRefresh:
        return "/auth/refresh"
      case .withdraw:
        return "/users/withdraw"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .join, .emailValidation, .login:
        return [
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
      
      case .tokenRefresh:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken),
          HTTPHeader(name: KCHeader.Key.refresh, value: UserInfoService.refreshToken)
        ]
        
      case .withdraw:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .join, .emailValidation, .login, .tokenRefresh, .withdraw:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .join(let request):
        return requestToBody(request)
      case .emailValidation(let request):
        return requestToBody(request)
      case .login(let request):
        return requestToBody(request)
      case .tokenRefresh, .withdraw:
        return nil
    }
  }
}
