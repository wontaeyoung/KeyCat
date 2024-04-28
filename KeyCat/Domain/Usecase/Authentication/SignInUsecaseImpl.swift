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
  private let userRepository: UserRepository
  
  init(
    authRepository: AuthRepository = AuthRepositoryImpl(),
    userRepository: UserRepository = UserRepositoryImpl()
  ) {
    self.authRepository = authRepository
    self.userRepository = userRepository
  }
  
  func execute(email: String, password: String) -> Single<Void> {
    return authRepository.signIn(email: email, password: password)
      .flatMap { _ in
        return self.userRepository.fetchMyProfile()
      }
      .do {
        UserInfoService.hasSellerAuthority = $0.userType == .seller
      }
      .map { _ in () }
  }
}
