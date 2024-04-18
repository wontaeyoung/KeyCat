//
//  PostRouter.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Foundation
import Alamofire

enum PostRouter: Router {
  
  case postImageUpload
  case postCreate(request: PostRequest)
  case postsFetch(query: FetchPostsQuery)
  case specificPostFetch(id: Entity.PostID)
  case postUpdate(id: Entity.PostID, request: PostRequest)
  case postDelete(id: Entity.PostID)
  case postsFromUserFetch(userID: Entity.UserID, query: FetchPostsQuery)
  case postsWithHashtagFetch(query: SearchHashtagQuery)
  
  var method: HTTPMethod {
    switch self {
      case .postImageUpload, .postCreate:
        return .post
      
      case .postsFetch, .specificPostFetch, .postsFromUserFetch, .postsWithHashtagFetch:
        return .get
      
      case .postUpdate:
        return .put
        
      case .postDelete:
        return .delete
    }
  }
  
  var path: String {
    switch self {
      case .postImageUpload:
        return "/posts/files"
      
      case .postCreate, .postsFetch:
        return "/posts"
      
      case .specificPostFetch(let postID):
        return "/posts/\(postID)"
      
      case let .postUpdate(postID, _):
        return "/posts/\(postID)"
        
      case .postDelete(let postID):
        return "/posts/\(postID)"
        
      case let .postsFromUserFetch(userID, _):
        return "/posts/users/\(userID)"
        
      case .postsWithHashtagFetch:
        return "/posts/hashtags"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .postImageUpload:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: APITokenContainer.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.multipartFormData)
        ]
        
      case .postCreate, .postUpdate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: APITokenContainer.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
        
      case .postsFetch, .specificPostFetch, .postDelete, .postsFromUserFetch, .postsWithHashtagFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: APITokenContainer.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .postImageUpload, .postCreate, .specificPostFetch, .postUpdate, .postDelete:
        return nil
      
      case .postsFetch(let query):
        return makeFetchPostsParameters(query: query)
        
      case let .postsFromUserFetch(_, query):
        return makeFetchPostsParameters(query: query)
        
      case .postsWithHashtagFetch(let query):
        return makeFetchHastagPostsParameters(query: query)
    }
  }
  
  var body: Data? {
    switch self {
      case .postImageUpload, .postsFetch, .specificPostFetch, .postDelete, .postsFromUserFetch, .postsWithHashtagFetch:
        return nil
      
      case .postCreate(let request):
        return requestToBody(request)
      
      case let .postUpdate(_, request):
        return requestToBody(request)
    }
  }
}

extension PostRouter: URLConvertible {
  func asURL() throws -> URL {
    guard let url = try asURLRequest().url else {
      throw HTTPError.invalidURL
    }
    
    return url
  }
}

extension PostRouter {
  private func makeFetchPostsParameters(query: FetchPostsQuery) -> Parameters {
    return [
      KCParameter.Key.next: query.next,
      KCParameter.Key.limit: query.limit,
      KCParameter.Key.productID: query.postType.productID
    ]
  }
  
  private func makeFetchHastagPostsParameters(query: SearchHashtagQuery) -> Parameters {
    return [
      KCParameter.Key.next: query.next,
      KCParameter.Key.limit: query.limit,
      KCParameter.Key.productID: query.postType.productID,
      KCParameter.Key.hashtag: query.hashTag
    ]
  }
}
