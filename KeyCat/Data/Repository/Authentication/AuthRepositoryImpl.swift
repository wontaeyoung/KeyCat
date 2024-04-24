//
//  AuthRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

import RxSwift

final class AuthRepositoryImpl: AuthRepository, HTTPErrorTransformer {
  
  private let service: APIService
  private let userMapper: UserMapper
  
  init(
    service: APIService = APIService(),
    userMapper: UserMapper = UserMapper()
  ) {
    self.service = service
    self.userMapper = userMapper
  }
  
  func checkEmailDuplication(email: String) -> Single<Bool> {
    let request = EmailValidationRequest(email: email)
    let router = AuthRouter.emailValidation(request: request)
    
    return service.callReqeust(with: router)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .emailValidation)
        return .error(domainError)
      }
  }
  
  func authenticateBusinessInfo(businessNumber: String) -> Single<BusinessInfo> {
    let request = BusinessInfoRequest(b_no: businessNumber)
    let router = BusinessInfoRouter.fetchStatus(request: request)
    
    return service.callRequest(with: router, of: BusinessInfoResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .none)
        return .error(domainError)
      }
      .flatMap {
        guard let businessInfoDTO = $0.data.first else {
          return .error(KCError.serverError)
        }
        
        return .just(businessInfoDTO)
      }
      .map { self.userMapper.toEntity($0) }
  }
}
