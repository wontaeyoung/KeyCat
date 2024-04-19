//
//  SignInViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/18/24.
//

import RxSwift
import RxCocoa

final class SignInViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let email: PublishRelay<String>
    let password: PublishRelay<String>
    let loginButtonTapEvent: PublishRelay<Void>
    let signUpButtonTapEvent: PublishRelay<Void>
  }
  
  struct Output {
    let loginEnable: Driver<Bool>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let emailValidation = input.email
      .map { !$0.isEmpty }
    
    let passwordValidation = input.password
      .map { !$0.isEmpty }
    
    let loginButtonEnable = Observable.combineLatest(emailValidation, passwordValidation)
      .map { $0 && $1 }
      .asDriver(onErrorJustReturn: false)
    
    return Output(loginEnable: loginButtonEnable)
  }
}

