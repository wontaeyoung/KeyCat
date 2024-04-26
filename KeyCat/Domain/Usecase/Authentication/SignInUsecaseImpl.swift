//
//  SignInUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

final class SignInUsecaseImpl: SignInUsecase {
  
  private let authRepository: AuthRepository
  
  init(authRepository: AuthRepository = AuthRepositoryImpl()) {
    self.authRepository = authRepository
  }
  
  func execute(email: String, password: String) -> Single<Void> {
    return authRepository.signIn(email: email, password: password)
      .map { _ in () }
  }
}
