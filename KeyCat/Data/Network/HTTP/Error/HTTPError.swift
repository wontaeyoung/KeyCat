//
//  HTTPError.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

enum HTTPError: AppError {
  
  typealias HTTPStatus = Int
  
  case unexceptedResponse(status: HTTPStatus)
  case invalidURL
  case requestFailed
  case unknown(error: Error)
  
  public var logDescription: String {
    switch self {
      case .unexceptedResponse(let status):
        return "응답 실패, 상태값 : \(status)"
        
      case .invalidURL:
        return "유효하지 않은 URL입니다."
        
      case .requestFailed:
        return "요청에 실패했습니다."
        
      case .unknown(let error):
        return "알 수 없는 오류가 발생했습니다. 에러 설명 : \(error.localizedDescription)"
    }
  }
  
  public var alertDescription: String {
    switch self {
      case .unexceptedResponse:
        return "데이터 응답에 실패했어요. 잠시 후 다시 시도해주세요. 문제가 계속되면 개발자에게 문의해주세요."
        
      case .invalidURL:
        return "요청하신 주소를 찾을 수 없어요. 주소를 확인하고 다시 시도해주세요."
        
      case .requestFailed:
        return "요청에 실패했어요. 와이파이 연결을 확인하거나 데이터 네트워크 상태를 확인하시고, 잠시 후 다시 시도해주세요."
        
      case .unknown:
        return "알 수 없는 문제가 발생했어요. 문제가 지속되면 개발자에게 문의해주세요."
    }
  }
}
