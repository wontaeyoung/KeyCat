//
//  CommentRouter.swift
//  KeyCat
//
//  Created by 원태영 on 4/17/24.
//

import Foundation
import Alamofire

enum CommentRouter: Router {
  
  case commentCreate(postID: Entity.PostID, request: CommentRequest)
  
  var method: HTTPMethod {
    switch self {
      case .commentCreate:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case let .commentCreate(postID, _):
        return "/posts/\(postID)/comments"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .commentCreate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .commentCreate:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case let .commentCreate(_, request):
        return requestToBody(request)
    }
  }
}
