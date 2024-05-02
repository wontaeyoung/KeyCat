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
  case like2(postID: Entity.PostID, request: LikePostRequest)
  case like2PostsFetch(query: FetchLikePostsQuery)
  
  var method: HTTPMethod {
    switch self {
      case .like, .like2:
        return .post
      
      case .likePostsFetch, .like2PostsFetch:
        return .get
    }
  }
  
  var path: String {
    switch self {
      case let .like(postID, _):
        return "/posts/\(postID)/like"
        
      case .likePostsFetch:
        return "/posts/likes/me"
        
      case let .like2(postID, _):
        return "/posts/\(postID)/like-2"
      
      case .like2PostsFetch:
        return "/posts/likes-2/me"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .like, .like2:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
        
      case .likePostsFetch, .like2PostsFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .like, .like2:
        return nil
        
      case .likePostsFetch(let query):
        return makeFetchPostsParameters(query: query)
        
      case .like2PostsFetch(let query):
        return makeFetchPostsParameters(query: query)
    }
  }
  
  var body: Data? {
    switch self {
      case let .like(_, request):
        return requestToBody(request)
        
      case let .like2(_, request):
        return requestToBody(request)
        
      case .likePostsFetch, .like2PostsFetch:
        return nil
    }
  }
}

extension LikeRouter {
  private func makeFetchPostsParameters(query: FetchLikePostsQuery) -> Parameters {
    return [
      KCParameter.Key.next: query.next,
      KCParameter.Key.limit: query.limit
    ]
  }
}
