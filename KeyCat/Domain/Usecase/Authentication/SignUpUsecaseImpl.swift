//
//  SignUpUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

final class SignUpUsecaseImpl: SignUpUsecase {
  
  private let authRepository: AuthRepository
  private let userRepository: UserRepository
  
  init(
    authRepository: AuthRepository = AuthRepositoryImpl(),
    userRepository: UserRepository = UserRepositoryImpl()
  ) {
    self.authRepository = authRepository
    self.userRepository = userRepository
  }
  
  func execute(
    email: String,
    password: String,
    nickname: String,
    profileData: Data?,
    userType: Profile.UserType
  ) -> Single<Bool> {
    
    return authRepository.signUp(email: email, password: password, nickname: nickname, userType: userType)
      .flatMap { _ in
        return self.authRepository.signIn(email: email, password: password)
      }
      .flatMap { _ in
        return self.userRepository.updateProfileImage(with: profileData)
      }
      .flatMap { _ in
        return .just(true)
      }
  }
}
