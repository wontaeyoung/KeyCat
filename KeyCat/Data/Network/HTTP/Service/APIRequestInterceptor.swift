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
      UserInfoService.hasSignInLog
    else {
      completion(.success(urlRequest))
      return
    }
    
    let urlRequest = urlRequest.applied {
      $0.setValue(UserInfoService.accessToken, forHTTPHeaderField: KCHeader.Key.authorization)
    }
    
    completion(.success(urlRequest))
  }
  
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: any Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    
    /// 에러 케이스가 419면 토큰 리프레시, 아니면 함수 종료
    guard 
      let statusCode = request.response?.statusCode,
      statusCode == HTTPStatusError.accessTokenExpired.statusCode
    else {
      return completion(.doNotRetry)
    }
      
    AF.request(AuthRouter.tokenRefresh)
      .validate()
      .responseDecodable(of: RefreshTokenResponse.self) { response in
        
        switch response.result {
          case .success(let tokenResponse):
            UserInfoService.renewAccessToken(with: tokenResponse.accessToken)
            completion(.retry)
            
          case .failure:
            completion(.doNotRetryWithError(HTTPStatusError.refreshTokenExpired))
        }
      }
  }
}
