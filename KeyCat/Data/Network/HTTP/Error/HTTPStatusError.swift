//
//  HTTPStatusError.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

enum HTTPStatusError: Int, AppError {
  
  case unknown = 0
  case refreshTokenExpired = 418
  case accessTokenExpired = 419
  
  init(_ rawValue: RawValue) {
    self = HTTPStatusError(rawValue: rawValue) ?? .unknown
  }
  
  var statusCode: Int {
    return self.rawValue
  }
  
  var logDescription: String {
    switch self {
      case .unknown:
        return "미정의 에러 발생"
        
      case .refreshTokenExpired:
        return "리프레시 토큰 만료"
        
      case .accessTokenExpired:
        return "액세스 토큰 만료"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .unknown, .accessTokenExpired:
        return ""
        
      case .refreshTokenExpired:
        return "로그인 정보가 만료됐어요. 안전을 위해 다시 로그인해주세요!"
    }
  }
}
