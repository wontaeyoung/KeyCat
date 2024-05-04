//
//  CheckEmailDuplicationUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

import RxSwift

final class CheckEmailDuplicationUsecaseImpl: CheckEmailDuplicationUsecase {
  
  private let authRepository: AuthRepository
  
  init(authRepository: AuthRepository = AuthRepositoryImpl()) {
    self.authRepository = authRepository
  }
  
  func execute(email: String) -> Single<Void> {
    
    return authRepository.checkEmailDuplication(email: email)
  }
}
