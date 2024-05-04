//
//  FetchProfileUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

final class FetchProfileUsecaseImpl: FetchProfileUsecase {
  
  private let userRepository: UserRepository
  
  init(
    userRepository: UserRepository = UserRepositoryImpl()
  ) {
    self.userRepository = userRepository
  }
  
  func fetchMyProfile() -> Single<Profile> {
    return userRepository.fetchMyProfile()
  }
}

