//
//  HTTPError.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

enum HTTPError: AppError {
  
  case invalidURL
  case requestFailed
  case noData
  case invalidResponse
  case unexceptedResponse(status: Int)
  case dataDecodingFailed
  
  public var logDescription: String {
    switch self {
      case .invalidURL:
        return "유효하지 않은 URL입니다."
        
      case .requestFailed:
        return "요청에 실패했습니다."
        
      case .noData:
        return "응답 데이터를 찾을 수 없습니다."
        
      case .invalidResponse:
        return "유효하지 않은 응답입니다."
        
      case .unexceptedResponse(let status):
        return "응답 실패, 상태값 : \(status)"
        
      case .dataDecodingFailed:
        return "데이터 디코딩에 실패했습니다."
    }
  }
  
  public var alertDescription: String {
    switch self {
      case .invalidURL:
        return "요청하신 주소를 찾을 수 없어요. 주소를 확인하고 다시 시도해주세요."
        
      case .requestFailed:
        return "요청에 실패했어요. 와이파이 연결을 확인하거나 데이터 네트워크 상태를 확인하시고, 잠시 후 다시 시도해주세요."
        
      case .noData, .invalidResponse, .unexceptedResponse, .dataDecodingFailed:
        return "데이터 응답에 실패했어요. 잠시 후 다시 시도해주세요. 문제가 계속되면 개발자에게 문의해주세요."
    }
  }
}
