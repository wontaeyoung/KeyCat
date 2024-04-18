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
  case myProfileUpdate(request: UpdateMyProfileRequest)
  
  var method: HTTPMethod {
    switch self {
      case .follow:
        return .post
        
      case .unfollow:
        return .delete
        
      case .myProfileFetch:
        return .get
        
      case .myProfileUpdate:
        return .put
    }
  }
  
  var path: String {
    switch self {
      case .follow(let userID):
        return "/follow/\(userID)"
        
      case .unfollow(let userID):
        return "/follow/\(userID)"
        
      case .myProfileFetch, .myProfileUpdate:
        return "/users/me/profile"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .follow, .unfollow, .myProfileFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken)
        ]
        
      case .myProfileUpdate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.multipartFormData),
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .follow, .unfollow, .myProfileFetch, .myProfileUpdate:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .follow, .unfollow, .myProfileFetch:
        return nil
        
      case .myProfileUpdate(let request):
        return requestToBody(request)
    }
  }
}

extension UserRouter: URLConvertible {
  func asURL() throws -> URL {
    guard let url = try asURLRequest().url else {
      throw HTTPError.invalidURL
    }
    
    return url
  }
}
