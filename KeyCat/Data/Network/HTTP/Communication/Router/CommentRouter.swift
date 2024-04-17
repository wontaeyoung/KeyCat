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
  case commentUpdate(postID: Entity.PostID, commentID: Entity.CommentID, request: CommentRequest)
  
  var method: HTTPMethod {
    switch self {
      case .commentCreate:
        return .post
        
      case .commentUpdate:
        return .put
    }
  }
  
  var path: String {
    switch self {
      case let .commentCreate(postID, _):
        return "/posts/\(postID)/comments"
        
      case let .commentUpdate(postID, commentID, _):
        return "/posts/\(postID)/comments/\(commentID)"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .commentCreate, .commentUpdate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .commentCreate, .commentUpdate:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case let .commentCreate(_, request):
        return requestToBody(request)
        
      case let .commentUpdate(_, _, request):
        return requestToBody(request)
    }
  }
}
