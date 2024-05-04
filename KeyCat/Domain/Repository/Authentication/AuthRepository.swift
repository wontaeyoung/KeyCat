//
//  AuthRepository.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

import RxSwift

protocol AuthRepository {
  
  func checkEmailDuplication(email: String) -> Single<Void>
  func authenticateBusinessInfo(businessNumber: String) -> Single<BusinessInfo>
  func signUp(email: String, password: String, nickname: String, userType: Profile.UserType) -> Single<User>
  func signIn(email: String, password: String) -> Single<User>
}
