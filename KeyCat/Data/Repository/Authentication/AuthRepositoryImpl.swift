//
//  AuthRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

import RxSwift

final class AuthRepositoryImpl: AuthRepository, HTTPErrorTransformer {
  
  private let service = APIService()
  
  func checkEmailDuplication(email: String) -> Single<Bool> {
    let request = EmailValidationRequest(email: email)
    let router = AuthRouter.emailValidation(request: request)
    
    return service.callReqeust(with: router)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .emailValidation)
        return .error(domainError)
      }
  }
}
