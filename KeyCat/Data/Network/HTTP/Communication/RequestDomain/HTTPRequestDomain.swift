//
//  HTTPRequestStyle.swift
//  KeyCat
//
//  Created by 원태영 on 4/21/24.
//

/// 상태코드를 공유하는 도메인 케이스를 구별하기 위한 열거형
enum HTTPRequestDomain {
  
  // 401
  case signIn
  
  // 409
  case emailValidation
  case signUp
  
  case none
}
