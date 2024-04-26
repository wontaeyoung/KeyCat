//
//  HTTPStatusError.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

enum HTTPStatusError: Int, Error {
  
  case unknown = 0
  case missingRequired = 400 // 필수값 누락
  case accessFailed = 401 // 유효하지 않은 로그인 정보, 액세스 토큰
  case forbidden = 403 // 접근 권한 없음
  case conflict = 409 // 이미 가입, 처리된 요청
  case targetNotFound = 410 // 생성 - 실패, 수정/삭제 - 존재하지 않는 대상에 대한 처리 요청
  case refreshTokenExpired = 418 // 리프레시 토큰 만료
  case accessTokenExpired = 419 // 액세스 토큰 만료
  case noAPIKey = 420 // 유효하지 않은 SesacKey
  case overcall = 429 // 과호출
  case invalidURL = 444 // 비정상 URL
  case noAuthority = 445 // 작업 요청 권한 없음(ex. 본인이 작성하지 않은 포스트에 수정 요청)
  case serverError = 500 // 서버 에러
  
  init(_ rawValue: RawValue) {
    self = HTTPStatusError(rawValue: rawValue) ?? .unknown
  }
  
  var statusCode: Int {
    return self.rawValue
  }
  
  var toDomain: KCError {
    switch self {
      case .missingRequired:
        return .missingRequired
      
      case .refreshTokenExpired:
        return .retrySignIn
      
      case .overcall:
        return .overcall
      
      case .noAuthority:
        return .noAuthority
      
      case .serverError:
        return .serverError
        
      default:
        return .unknown
    }
  }
}
