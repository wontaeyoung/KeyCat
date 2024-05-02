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
  
  private let email = BehaviorRelay<String>(value: "")
  private let password = BehaviorRelay<String>(value: "")
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  private let signInUsecase: SignInUsecase
  
  // MARK: - Initializer
  init(signInUsecase: SignInUsecase = SignInUsecaseImpl()) {
    self.signInUsecase = signInUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    /// 이메일 입력 전달
    input.email
      .bind(to: email)
      .disposed(by: disposeBag)
    
    /// 비밀번호 입력 전달
    input.password
      .bind(to: password)
      .disposed(by: disposeBag)
    
    /// 이메일 필드 비어있는지 검사
    let emailValidation = input.email
      .map { $0.isFilled }
    
    /// 비밀번호 필드 비어있는지 검사
    let passwordValidation = input.password
      .map { !$0.isFilled }
    
    /// 두 필드가 모두 비어있지 않을 때 로그인 버튼 활성화
    let loginButtonEnable = Observable.combineLatest(emailValidation, passwordValidation)
      .map { $0 && $1 }
      .asDriver(onErrorJustReturn: false)
    
    /// 로그인 이벤트 > 로그인 로직 호출
    input.loginButtonTapEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.signInUsecase.execute(email: owner.email.value, password: owner.password.value)
          .catch { error in
            owner.coordinator?.showErrorAlert(error: error)
            return .never()
          }
      }
      .bind(with: self) { owner, _ in
        owner.coordinator?.end()
      }
      .disposed(by: disposeBag)
    
    /// 회원가입 버튼 탭 이벤트 회원가입 플로우 연결
    input.signUpButtonTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpView()
      }
      .disposed(by: disposeBag)
    
    return Output(loginEnable: loginButtonEnable)
  }
}
