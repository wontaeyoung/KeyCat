//
//  AuthRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

import RxSwift

final class AuthRepositoryImpl: AuthRepository, HTTPErrorTransformer {
  
  private let service: APIService
  private let userMapper: UserMapper
  
  init(
    service: APIService = APIService(),
    userMapper: UserMapper = UserMapper()
  ) {
    self.service = service
    self.userMapper = userMapper
  }
  
  func checkEmailDuplication(email: String) -> Single<Void> {
    let request = EmailValidationRequest(email: email)
    let router = AuthRouter.emailValidation(request: request)
    
    return service.callReqeust(with: router)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .emailValidation)
        return .error(domainError)
      }
  }
  
  func authenticateBusinessInfo(businessNumber: String) -> Single<BusinessInfo> {
    let request = BusinessInfoRequest(b_no: businessNumber)
    let router = BusinessInfoRouter.fetchStatus(request: request)
    
    return service.callRequest(with: router, of: BusinessInfoResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .none)
        return .error(domainError)
      }
      .flatMap {
        guard let businessInfoDTO = $0.data.first else {
          return .error(KCError.serverError)
        }
        
        return .just(businessInfoDTO)
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func signUp(
    email: String,
    password: String,
    nickname: String,
    userType: Profile.UserType
  ) -> Single<User> {
    let request = JoinRequest(email: email, password: password, nick: nickname, phoneNum: userType.rawValue.description, birthDay: nil)
    let router = AuthRouter.join(request: request)
    
    return service.callRequest(with: router, of: AuthResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .signUp)
        return .error(domainError)
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func signIn(email: String, password: String) -> Single<User> {
    let request = LoginRequest(email: email, password: password)
    let router = AuthRouter.login(request: request)
    
    return service.callRequest(with: router, of: LoginResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .signIn)
        return .error(domainError)
      }
      .do { response in
        UserInfoService.login(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          userID: response.user_id
        )
      }
      .map { self.userMapper.toEntity($0) }
  }
  
  func withdraw() -> Single<Void> {
    let router = AuthRouter.withdraw
    
    return service.callRequest(with: router, of: AuthResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .withdraw)
        return .error(domainError)
      }
      .map { _ in () }
  }
}
