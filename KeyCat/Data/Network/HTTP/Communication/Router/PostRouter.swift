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
  
  var method: HTTPMethod {
    switch self {
      case .postImageUpload, .postCreate:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case .postImageUpload:
        return "/posts/files"
      case .postCreate:
        return "/posts"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .postImageUpload:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.multipartFormData)
        ]
        
      case .postCreate:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .postImageUpload, .postCreate:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .postImageUpload:
        return nil
      case .postCreate(let request):
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
