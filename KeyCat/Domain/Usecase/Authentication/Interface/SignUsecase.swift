//
//  SignUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

protocol SignUsecase {
  
  func signUp(email: String, password: String, nickname: String, profileData: Data?, userType: Profile.UserType) -> Single<Bool>
  func signIn(email: String, password: String) -> Single<Void>
}
