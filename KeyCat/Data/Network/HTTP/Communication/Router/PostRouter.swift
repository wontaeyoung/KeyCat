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
  
  var method: HTTPMethod {
    switch self {
      case .postImageUpload:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case .postImageUpload:
        return "/posts/files"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .postImageUpload:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: KCHeader.Value.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.multipartFormData)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .postImageUpload:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .postImageUpload:
        return nil
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
