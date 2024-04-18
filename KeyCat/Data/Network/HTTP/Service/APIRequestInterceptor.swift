//
//  APIRequestInterceptor.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import Foundation
import Alamofire

final class APIRequestInterceptor: RequestInterceptor {
  
  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, any Error>) -> Void
  ) {
    /// 최초 로그인 시 토큰이 없기 때문에 종료
    guard
      let urlString = urlRequest.url?.absoluteString,
      urlString.hasPrefix(APIKey.baseURL),
      APITokenContainer.hasSignInLog
    else {
      completion(.success(urlRequest))
      return
    }
    
    let urlRequest = urlRequest.applied {
      $0.setValue(APITokenContainer.accessToken, forHTTPHeaderField: KCHeader.Key.authorization)
      $0.setValue(APITokenContainer.refreshToken, forHTTPHeaderField: KCHeader.Key.refresh)
    }
    
    completion(.success(urlRequest))
  }
  
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: any Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    let router = AuthRouter.tokenRefresh
    
    AF.request(router)
      .responseDecodable(of: RefreshTokenResponse.self) { response in
        
        let passStatusCode = [200, 418, 419]
        
        guard
          let statusCode = response.response?.statusCode,
          passStatusCode.contains(statusCode)
        else {
          return completion(.doNotRetry)
        }
        
        switch response.result {
          case .success(let tokenResponse):
            APITokenContainer.accessToken = tokenResponse.accessToken
            completion(.retry)
            
          case .failure:
            completion(.doNotRetryWithError(HTTPStatusError.refreshTokenExpired))
        }
      }
  }
}
