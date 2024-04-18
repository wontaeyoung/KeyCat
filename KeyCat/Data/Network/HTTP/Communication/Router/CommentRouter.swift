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
  case commentDelete(postID: Entity.PostID, commentID: Entity.CommentID)
  
  var method: HTTPMethod {
    switch self {
      case .commentCreate:
        return .post
        
      case .commentUpdate:
        return .put
        
      case .commentDelete:
        return .delete
    }
  }
  
  var path: String {
    switch self {
      case let .commentCreate(postID, _):
        return "/posts/\(postID)/comments"
        
      case let .commentUpdate(postID, commentID, _):
        return "/posts/\(postID)/comments/\(commentID)"
        
      case let .commentDelete(postID, commentID):
        return "/posts/\(postID)/comments/\(commentID)"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .commentCreate, .commentUpdate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: APITokenContainer.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
        
      case .commentDelete:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: APITokenContainer.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .commentCreate, .commentUpdate, .commentDelete:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case let .commentCreate(_, request):
        return requestToBody(request)
        
      case let .commentUpdate(_, _, request):
        return requestToBody(request)
        
      case .commentDelete:
        return nil
    }
  }
}
