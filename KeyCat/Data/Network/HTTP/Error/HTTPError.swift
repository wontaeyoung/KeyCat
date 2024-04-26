//
//  HTTPError.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

enum HTTPError: AppError {
  
  typealias HTTPStatus = Int
  
  case requestFailed
  case unexceptedResponse(status: HTTPStatus)
  
  var logDescription: String {
    switch self {
      case .requestFailed:
        return "요청에 실패했습니다."
        
      case .unexceptedResponse(let status):
        return "응답 실패, 상태값 : \(status)"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .requestFailed:
        return "요청에 실패했어요. 와이파이 연결을 확인하거나 데이터 네트워크 상태를 확인하시고, 잠시 후 다시 시도해주세요."
        
      case .unexceptedResponse:
        return "데이터 응답에 실패했어요. 잠시 후 다시 시도해주세요. 문제가 계속되면 개발자에게 문의해주세요."
    }
  }
}
