//
//  UserInteractionUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

final class UserInteractionUsecaseImpl: UserInteractionUsecase {
  
  private let userRepository: UserRepository
  
  init(
    userRepository: UserRepository = UserRepositoryImpl()
  ) {
    self.userRepository = userRepository
  }
  
  func follow(userID: User.UserID) -> Single<Bool> {
    return userRepository.follow(userID: userID)
  }
  
  func unfollow(userID: User.UserID) -> Single<Bool> {
    return userRepository.unfollow(userID: userID)
  }
}

