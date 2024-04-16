//
//  Router.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Foundation
import Alamofire

protocol Router: URLRequestConvertible {
  
  var method: HTTPMethod { get }
  var baseURL: String { get }
  var path: String { get }
  var defaultHeaders: HTTPHeaders { get }
  var optionalHeaders: HTTPHeaders { get }
  var headers: HTTPHeaders { get }
  var parameters: Parameters? { get }
  var body: Data? { get }
}

extension Router {
  
  var baseURL: String {
    return APIKey.baseURL
  }
  
  var defaultHeaders: HTTPHeaders {
    return [
      HTTPHeader(name: KCHeader.Key.sesacKey, value: APIKey.sesacKey)
    ]
  }
  
  var headers: HTTPHeaders {
    return defaultHeaders.combined(headers: optionalHeaders)
  }
  
  func asURLRequest() throws -> URLRequest {
    guard let url = URL(string: baseURL + path) else { throw HTTPError.invalidURL }
    
    let request = URLRequest(url: url).applied {
      $0.httpMethod = method.rawValue
      $0.headers = headers
      $0.httpBody = body
    }
    
    guard let parameters else {
      return request
    }
    
    return try URLEncoding.default.encode(request, with: parameters)
  }
}
