//
//  SignUpViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let email: PublishRelay<String>
    let duplicateCheckEvent: PublishRelay<Void>
    let emailNextEvent: PublishRelay<Void>
    
    let password: PublishRelay<String>
    let passwordCheck: PublishRelay<String>
    let passwordNextEvent: PublishRelay<Void>
    
    init(
      sellerAuthorityNextEvent: PublishRelay<Void> = .init(),
      onlyCustomerAuthorityNextEvent: PublishRelay<Void> = .init(),
      businessInfoAuthenticationEvent: PublishRelay<String> = .init(),
      businessInfoAuthenticationNextEvent: PublishRelay<Void> = .init(),
      email: PublishRelay<String> = .init(),
      duplicateCheckEvent: PublishRelay<Void> = .init(),
      emailNextEvent: PublishRelay<Void> = .init(),
      password: PublishRelay<String> = .init(),
      passwordCheck: PublishRelay<String> = .init(),
      passwordNextEvent: PublishRelay<Void> = .init()
    ) {
      self.sellerAuthorityNextEvent = sellerAuthorityNextEvent
      self.onlyCustomerAuthorityNextEvent = onlyCustomerAuthorityNextEvent
      self.businessInfoAuthenticationEvent = businessInfoAuthenticationEvent
      self.businessInfoAuthenticationNextEvent = businessInfoAuthenticationNextEvent
      self.email = email
      self.duplicateCheckEvent = duplicateCheckEvent
      self.emailNextEvent = emailNextEvent
      self.password = password
      self.passwordCheck = passwordCheck
      self.passwordNextEvent = passwordNextEvent
    }
  }
  
  struct Output {
    let duplicateCheckResult: Driver<Bool>
    let showDuplicationCheckResultToast: Driver<Void>
    
    let passwordEqualValidationResult: Driver<Bool>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  
  private let email = BehaviorRelay<String>(value: "")
  private let password = BehaviorRelay<String>(value: "")
  private let nickname = BehaviorRelay<String>(value: "")
  private let sellingAuthority = BehaviorRelay<Bool>(value: false)
  
  // MARK: - Initializer
  init() {
    
  }
  
  private let checkEmailValidationUsecase: CheckEmailDuplicationUsecase = CheckEmailDuplicationUsecaseImpl()
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let duplicateCheckResult = BehaviorRelay<Bool>(value: false)
    let showDuplicationCheckResultToast = PublishRelay<Void>()
    let passwrodEqualValidationResult = BehaviorRelay<Bool>(value: false)
    
    /// 이메일 입력내용 전달
    input.email
      .bind(to: email)
      .disposed(by: disposeBag)
    
    /// 비밀번호 입력내용 전달
    input.password
      .bind(to: password)
      .disposed(by: disposeBag)
    
    /// 이메일이 변경되면 중복체크 결과 초기화
    input.email
      .map { _ in false }
      .bind(to: duplicateCheckResult)
      .disposed(by: disposeBag)
    
    /// 서버에 이메일 중복 검사 요청 후 응답 결과 전달
    input.duplicateCheckEvent
      .withLatestFrom(input.email)
      .withUnretained(self)
      .flatMap { owner, email in
        return owner.checkEmailValidationUsecase.execute(email: email)
          .catch { error in
            return Single.just(false)
          }
      }
      .bind {
        duplicateCheckResult.accept($0)
        showDuplicationCheckResultToast.accept(())
      }
      .disposed(by: disposeBag)

    /// 이메일 다음 버튼 이벤트 화면 연결
    input.emailNextEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpPasswordView()
      }
      .disposed(by: disposeBag)
    
    /// 비밀번호 == 비밀번호 필드, 두 필드가 모두 비어있지 않은지 검사해서 전달
    Observable.combineLatest(
      input.password,
      input.passwordCheck
    )
    .map { $0 == $1 && !$0.isEmpty && !$1.isEmpty }
    .bind(to: passwrodEqualValidationResult)
    .disposed(by: disposeBag)
    
    return Output(
      duplicateCheckResult: duplicateCheckResult.asDriver(),
      showDuplicationCheckResultToast: showDuplicationCheckResultToast.asDriver(onErrorJustReturn: ()),
      passwordEqualValidationResult: passwrodEqualValidationResult.asDriver()
    )
  }
}
