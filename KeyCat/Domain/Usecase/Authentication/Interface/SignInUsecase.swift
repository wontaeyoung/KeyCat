//
//  SignInUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import RxSwift

protocol SignInUsecase {
  
  func execute(email: String, password: String) -> Single<Void>
}
