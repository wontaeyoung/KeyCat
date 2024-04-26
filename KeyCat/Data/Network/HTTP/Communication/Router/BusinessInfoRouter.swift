//
//  BusinessInfoRouter.swift
//  KeyCat
//
//  Created by 원태영 on 4/23/24.
//

import Foundation
import Alamofire

enum BusinessInfoRouter: Router {
  
  case fetchStatus(request: BusinessInfoRequest)
  
  var baseURL: String {
    return APIKey.businessBaseURL
  }
  
  var method: HTTPMethod {
    switch self {
      case .fetchStatus:
        return .post
    }
  }
  
  var path: String {
    switch self {
      case .fetchStatus:
        return "/status?\(KCParameter.Key.serviceKey)=\(APIKey.businessServiceKey)"
    }
  }
  
  var defaultHeaders: HTTPHeaders {
    switch self {
      case .fetchStatus:
        return []
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .fetchStatus:
        return [HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .fetchStatus:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .fetchStatus(let request):
        return requestToBody(request)
    }
  }
}
