//
//  LikeRouter.swift
//  KeyCat
//
//  Created by 원태영 on 4/17/24.
//

import Foundation
import Alamofire

enum LikeRouter: Router {
  
  case like(postID: Entity.PostID, request: LikePostRequest)
  
  var method: HTTPMethod {
    switch self {
      case .like:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case let .like(postID, _):
        return "/posts/\(postID)/like"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .like:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .like:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case let .like(_, request):
        return requestToBody(request)   
    }
  }
}

