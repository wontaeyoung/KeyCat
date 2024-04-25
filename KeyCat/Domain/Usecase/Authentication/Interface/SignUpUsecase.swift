//
//  SignUpUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

protocol SignUpUsecase {
  
  func execute(email: String, password: String, nickname: String, profileData: Data?, userType: Profile.UserType) -> Single<Bool>
}
