//
//  SignUpViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let sellerAuthorityNextEvent: PublishRelay<Void>
    let onlyCustomerAuthorityNextEvent: PublishRelay<Void>
    
    let businessInfoAuthenticationEvent: PublishRelay<String>
    let businessInfoAuthenticationNextEvent: PublishRelay<Void>
    
    let email: PublishRelay<String>
    let duplicateCheckEvent: PublishRelay<Void>
    let emailNextEvent: PublishRelay<Void>
    
    let password: PublishRelay<String>
    let passwordCheck: PublishRelay<String>
    let passwordNextEvent: PublishRelay<Void>
    
    let nickname: PublishRelay<String>
    let profileNextEvent: PublishRelay<Data?>
    let signUpToastCompletedEvent: PublishRelay<Void>
    
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
      passwordNextEvent: PublishRelay<Void> = .init(),
      nickname: PublishRelay<String> = .init(),
      profileNextEvent: PublishRelay<Data?> = .init(),
      signUpToastCompletedEvent: PublishRelay<Void> = .init()
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
      self.nickname = nickname
      self.profileNextEvent = profileNextEvent
      self.signUpToastCompletedEvent = signUpToastCompletedEvent
    }
  }
  
  struct Output {
    let businessInfoAuthenticationResult: Driver<Bool>
    let showAuthenticationResultToast: Driver<String>
    
    let duplicateCheckResult: Driver<Bool>
    let showDuplicationCheckResultToast: Driver<Void>
    
    let passwordEqualValidationResult: Driver<Bool>
    
    let signUpCompleted: Driver<Void>
    let signUpFailed: Driver<Void>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  private let checkEmailValidationUsecase: CheckEmailDuplicationUsecase
  private let authenticateBusinessInfoUsecase: AuthenticateBusinessInfoUsecase
  private let signUpUsecase: SignUpUsecase
  
  private let email = BehaviorRelay<String>(value: "")
  private let password = BehaviorRelay<String>(value: "")
  private let nickname = BehaviorRelay<String>(value: "")
  private let businessInfoAuthenticated = BehaviorRelay<Bool>(value: false)
  
  // MARK: - Initializer
  init(
    checkEmailValidationUsecase: any CheckEmailDuplicationUsecase = CheckEmailDuplicationUsecaseImpl(),
    authenticateBusinessInfoUsecase: any AuthenticateBusinessInfoUsecase = AuthenticateBusinessInfoUsecaseImpl(),
    signUpUsecase: any SignUpUsecase = SignUpUsecaseImpl()
  ) {
    self.checkEmailValidationUsecase = checkEmailValidationUsecase
    self.authenticateBusinessInfoUsecase = authenticateBusinessInfoUsecase
    self.signUpUsecase = signUpUsecase
  }
  
  // MARK: - Method
  @discardableResult 
  func transform(input: Input) -> Output {
    
    let showAuthenticationResultToast = PublishRelay<String>()
    
    let duplicateCheckResult = BehaviorRelay<Bool>(value: false)
    let showDuplicationCheckResultToast = PublishRelay<Void>()
    
    let passwordEqualValidationResult = BehaviorRelay<Bool>(value: false)
    let signUpCompleted = PublishRelay<Void>()
    let signUpFailed = PublishRelay<Void>()
    
    /// 사업자 번호 등록여부 응답 결과
    let businessInfoAuthentication = input.businessInfoAuthenticationEvent
      .withUnretained(self)
      .flatMap { owner, businessNumber in
        return owner.authenticateBusinessInfoUsecase.execute(businessNumber: businessNumber)
          .catch { error in
            owner.coordinator?.showErrorAlert(error: error)
            return .just(.unregistered)
          }
      }
    
    /// 사업자 등록 확인 결과 전달
    businessInfoAuthentication
      .map { $0.businessStatus == .active }
      .bind(to: businessInfoAuthenticated)
      .disposed(by: disposeBag)
    
    /// 사업자 등록 여부 체크 결과를 토스트 메세지로 전달
    businessInfoAuthentication
      .map { $0.businessStatus.statusMessage }
      .bind(to: showAuthenticationResultToast)
      .disposed(by: disposeBag)
    
    /// 판매자 권한이 필요하면 사업자 인증 화면으로 전환
    input.sellerAuthorityNextEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpBusinessInfoAuthenticationView()
      }
      .disposed(by: disposeBag)
    
    /// 판매자 권한이 필요하지 않으면 바로 이메일 화면으로 전환
    input.onlyCustomerAuthorityNextEvent
      .bind(with: self) { owner, _ in
        // 사업자 인증 -> 뒤로가기 -> 고객 플로우로 돌아오는 케이스에 대한 예외처리
        owner.businessInfoAuthenticated.accept(false)
        owner.coordinator?.showSignUpEmailView()
      }
      .disposed(by: disposeBag)
    
    /// 사업자 정보 다음 버튼 이벤트 화면 연결
    input.businessInfoAuthenticationNextEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpEmailView()
      }
      .disposed(by: disposeBag)
    
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
    .bind(to: passwordEqualValidationResult)
    .disposed(by: disposeBag)
    
    /// 비밀번호 다음 버튼 이벤트 화면 연결
    input.passwordNextEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpProfileView()
      }
      .disposed(by: disposeBag)
    
    /// 닉네임 입력내용 전달
    input.nickname
      .bind(to: nickname)
      .disposed(by: disposeBag)
    
    /// 회원가입 -> 로그인 -> 프로필 이미지 적용
    /// 성공하면 토스트 안내 후 coordinator end, 실패하면 인디케이터 중지 output
    input.profileNextEvent
      .withUnretained(self)
      .flatMap { owner, imageData in
        return owner.signUpUsecase.execute(
          email: owner.email.value,
          password: owner.password.value,
          nickname: owner.nickname.value,
          profileData: imageData,
          userType: owner.businessInfoAuthenticated.value ? .seller : .standard
        )
        .catch {
          owner.coordinator?.showErrorAlert(error: $0)
          return .just(false)
        }
      }
      .bind { success in
        if success {
          signUpCompleted.accept(())
        } else {
          signUpFailed.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    /// 토스트 표시가 완료되면 시작 화면으로 이동
    input.signUpToastCompletedEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.end()
      }
      .disposed(by: disposeBag)
    
    return Output(
      businessInfoAuthenticationResult: businessInfoAuthenticated.asDriver(),
      showAuthenticationResultToast: showAuthenticationResultToast.asDriver(onErrorJustReturn: "-"),
      duplicateCheckResult: duplicateCheckResult.asDriver(),
      showDuplicationCheckResultToast: showDuplicationCheckResultToast.asDriver(onErrorJustReturn: ()),
      passwordEqualValidationResult: passwordEqualValidationResult.asDriver(),
      signUpCompleted: signUpCompleted.asDriver(onErrorJustReturn: ()),
      signUpFailed: signUpFailed.asDriver(onErrorJustReturn: ())
    )
  }
}
