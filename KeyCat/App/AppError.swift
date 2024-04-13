//
//  AppError.swift
//  KeyCat
//
//  Created by 원태영 on 4/10/24.
//

protocol AppError: Error {
  var logDescription: String { get }
  var alertDescription: String { get }
}

enum CommonError: AppError {
  
  static let contactDeveloperInfoText: String = "문제가 다시 생기면 개발자에게 문의해주세요."
  
  case unknownError(error: Error?)
  case unExceptedNil
  
  var logDescription: String {
    switch self {
      case .unknownError(let error):
        return "알 수 없는 오류 발생 \(error?.localizedDescription ?? "")"
        
      case .unExceptedNil:
        return "Nil 객체 발생"
    }
  }
  
  var alertDescription: String {
    switch self {
      case .unknownError, .unExceptedNil:
        return "알 수 없는 오류가 발생했어요. 문제가 지속되면 개발자에게 문의해주세요."
    }
  }
}
