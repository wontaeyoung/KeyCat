//
//  UserRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

final class UserRepositoryImpl: UserRepository, HTTPErrorTransformer {
  
  private let service: APIService
  private let userMapper: UserMapper
  
  init(
    service: APIService = APIService(),
    userMapper: UserMapper = UserMapper()
  ) {
    self.service = service
    self.userMapper = userMapper
  }
  
  func updateProfileImage(with imageData: Data?) -> Single<Profile> {
    let request = UpdateMyProfileRequest(profile: imageData)
    let router = UserRouter.myProfileUpdate(request: request)
    
    return service.callRequest(with: router, of: ProfileDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .accessToken)
        return .error(domainError)
      }
      .map { self.userMapper.toEntity($0) }
  }
}
