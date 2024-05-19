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
    
    /// 로그인 요청은 Intercept 하지 않고 바로 실행
    guard
      let urlString = urlRequest.url?.absoluteString,
      urlString.hasPrefix(APIKey.baseURL),
      UserInfoService.hasSignInLog
    else {
      completion(.success(urlRequest))
      return
    }
    
    /// 갱신된 토큰으로 Header 재설정
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
      
    /// 토큰 리프레시 요청
    AF.request(AuthRouter.tokenRefresh)
      .validate()
      .responseDecodable(of: RefreshTokenResponse.self) { response in
        
        switch response.result {
            /// 응답 토큰으로 갱신 후 기존 API 재요청
          case .success(let tokenResponse):
            UserInfoService.renewAccessToken(with: tokenResponse.accessToken)
            completion(.retry)
            
            /// 리프레시 토큰이 만료되면 로그인 화면으로 돌아가도록 에러 방출
          case .failure:
            completion(.doNotRetryWithError(HTTPStatusError.refreshTokenExpired))
        }
      }
  }
}
