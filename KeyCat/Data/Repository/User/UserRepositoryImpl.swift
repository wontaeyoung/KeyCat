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
  
  func fetchSellerAuthority() -> Single<Bool> {
    return .just(UserInfoService.hasSellerAuthority)
  }
  
  func fetchMyProfile() -> Single<Profile> {
    let router = UserRouter.myProfileFetch
    
    return service.callRequest(with: router, of: ProfileDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .accessToken)
        return .error(domainError)
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func fetchOtherProfile(userID: User.UserID) -> Single<Profile> {
    let router = UserRouter.otherProfileFetch(userID: userID)
    
    return service.callRequest(with: router, of: ProfileDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .accessToken)
        return .error(domainError)
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func updateProfileImage(with imageData: Data?) -> Single<Profile> {
    guard let imageData else { return .just(.empty) }
    
    let request = UpdateMyProfileRequest(profile: imageData)
    
    return service.callUpdateProfileRequest(request: request)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .accessToken)
        return .error(domainError)
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func updateSellerAuthority() -> Single<Profile> {
    let request = UpdateMyProfileRequest(phoneNum: Profile.UserType.seller.rawValue.description)
    
    return service.callUpdateProfileRequest(request: request)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .accessToken)
        return .error(domainError)
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func updateProfile(nick: String?, profile: Data?) -> Single<Profile> {
    let request = UpdateMyProfileRequest(nick: nick, phoneNum: nil, birthDay: nil, profile: profile)
    
    return service.callUpdateProfileRequest(request: request)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .accessToken)
        return .error(domainError)
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func follow(userID: User.UserID) -> Single<Bool> {
    let router = UserRouter.follow(userID: userID)
    
    return service.callRequest(with: router, of: FollowDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .follow)
        return .error(domainError)
      }
      .map { $0.following_status }
  }
  
  func unfollow(userID: User.UserID) -> Single<Bool> {
    let router = UserRouter.unfollow(userID: userID)
    
    return service.callRequest(with: router, of: FollowDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .unfollow)
        return .error(domainError)
      }
      .map { $0.following_status }
  }
}
