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
  case postFetch(query: FetchPostsQuery)
  case specificPostFetch(id: Entity.PostID)
  case postUpdate(id: Entity.PostID, request: PostRequest)
  
  var method: HTTPMethod {
    switch self {
      case .postImageUpload, .postCreate:
        return .post
      
      case .postFetch, .specificPostFetch:
        return .get
      
      case .postUpdate:
        return .put
    }
  }
  
  var path: String {
    switch self {
      case .postImageUpload:
        return "/posts/files"
      
      case .postCreate, .postFetch:
        return "/posts"
      
      case .specificPostFetch(let postID):
        return "/posts/\(postID)"
      
      case let .postUpdate(postID, _):
        return "/posts/\(postID)"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .postImageUpload:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.multipartFormData)
        ]
        
      case .postCreate, .postUpdate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
        
      case .postFetch, .specificPostFetch:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .postImageUpload, .postCreate, .specificPostFetch, .postUpdate:
        return nil
      
      case .postFetch(let query):
        return [
          KCParameter.Key.next: query.next,
          KCParameter.Key.limit: query.limit,
          KCParameter.Key.productID: query.postType.productID
        ]
    }
  }
  
  var body: Data? {
    switch self {
      case .postImageUpload, .postFetch, .specificPostFetch:
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
