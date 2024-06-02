//
//  AuthenticateBusinessInfoUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/24/24.
//

import RxSwift

final class AuthenticateBusinessInfoUsecaseImpl: AuthenticateBusinessInfoUsecase {
  
  private let authRepository: any AuthRepository
  
  init(authRepository: any AuthRepository) {
    self.authRepository = authRepository
  }
  
  func execute(businessNumber: String) -> Single<BusinessInfo> {
    
    return authRepository.authenticateBusinessInfo(businessNumber: businessNumber)
  }
}
