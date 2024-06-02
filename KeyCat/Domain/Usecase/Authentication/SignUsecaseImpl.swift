//
//  SignUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

final class SignUsecaseImpl: SignUsecase {
  
  private let authRepository: any AuthRepository
  private let userRepository: any UserRepository
  
  init(
    authRepository: any AuthRepository,
    userRepository: any UserRepository
  ) {
    self.authRepository = authRepository
    self.userRepository = userRepository
  }
  
  func signUp(
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
  
  func signIn(email: String, password: String) -> Single<Void> {
    return authRepository.signIn(email: email, password: password)
      .flatMap { _ in
        return self.userRepository.fetchMyProfile()
      }
      .do {
        UserInfoService.hasSellerAuthority = $0.userType == .seller
      }
      .map { _ in () }
  }
  
  func withdraw() -> Single<Void> {
    return authRepository.withdraw()
  }
}
