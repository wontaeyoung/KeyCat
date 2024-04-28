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
  case otherProfileFetch(userID: Entity.UserID)
  
  var method: HTTPMethod {
    switch self {
      case .follow:
        return .post
        
      case .unfollow:
        return .delete
        
      case .myProfileFetch, .otherProfileFetch:
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
        
      case .otherProfileFetch(let userID):
        return "/users/\(userID)/profile"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .follow, .unfollow, .myProfileFetch, .otherProfileFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken)
        ]
        
      case .myProfileUpdate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.multipartFormData),
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .follow, .unfollow, .myProfileFetch, .myProfileUpdate, .otherProfileFetch:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .follow, .unfollow, .myProfileFetch, .otherProfileFetch:
        return nil
        
      case .myProfileUpdate(let request):
        return requestToBody(request)
    }
  }
}

extension UserRouter: URLConvertible {
  func asURL() throws -> URL {
    guard let url = try asURLRequest().url else {
      throw HTTPError.requestFailed
    }
    
    return url
  }
}
