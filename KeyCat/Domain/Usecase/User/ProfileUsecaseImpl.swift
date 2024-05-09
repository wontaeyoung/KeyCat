//
//  ProfileUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import Foundation
import RxSwift

final class ProfileUsecaseImpl: ProfileUsecase {
  
  private let userRepository: UserRepository
  
  init(
    userRepository: UserRepository = UserRepositoryImpl()
  ) {
    self.userRepository = userRepository
  }
  
  func fetchMyProfile() -> Single<Profile> {
    return userRepository.fetchMyProfile()
  }
  
  func fetchOtherProfile(userID: User.UserID) -> Single<Profile> {
    return userRepository.fetchOtherProfile(userID: userID)
  }
  
  func updateSellerAuthority() -> Single<Profile> {
    return userRepository.updateSellerAuthority()
  }
  
  func updateProfile(nick: String?, profile: Data?) -> Single<Profile> {
    return userRepository.updateProfile(nick: nick, profile: profile)
  }
}
