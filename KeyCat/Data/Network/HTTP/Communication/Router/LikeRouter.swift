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
  case likePostsFetch(query: FetchLikePostsQuery)
  
  var method: HTTPMethod {
    switch self {
      case .like:
        return .post
      
      case .likePostsFetch:
        return .get
    }
  }
  
  var path: String {
    switch self {
      case let .like(postID, _):
        return "/posts/\(postID)/like"
        
      case .likePostsFetch:
        return "/posts/likes/me"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .like, .likePostsFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .like:
        return nil
        
      case .likePostsFetch(let query):
        return [
          KCParameter.Key.next: query.next,
          KCParameter.Key.limit: query.limit,
        ]
    }
  }
  
  var body: Data? {
    switch self {
      case let .like(_, request):
        return requestToBody(request)
        
      case .likePostsFetch:
        return nil
    }
  }
}
