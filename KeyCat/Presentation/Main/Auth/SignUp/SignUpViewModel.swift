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
    let businessInfoAuthenticationNextEvent: PublishRelay<SignUpBusinessInfoAuthenticationViewController.AuthenticationCase>
    let email: PublishRelay<String>
    let duplicateCheckEvent: PublishRelay<Void>
    let emailNextEvent: PublishRelay<Void>
    let password: PublishRelay<String>
    let passwordCheck: PublishRelay<String>
    let passwordNextEvent: PublishRelay<Void>
    let nickname: PublishRelay<String>
    let profileNextEvent: PublishRelay<(Data?, SignUpProfileViewController.WriteProfileCase)>
    let signUpToastCompletedEvent: PublishRelay<Void>
    let updateSellerAuthorityTapEvent: PublishRelay<Void>
    let updateSellerToastCompletedEvent: PublishRelay<Void>
    
    init(
      sellerAuthorityNextEvent: PublishRelay<Void> = .init(),
      onlyCustomerAuthorityNextEvent: PublishRelay<Void> = .init(),
      businessInfoAuthenticationEvent: PublishRelay<String> = .init(),
      businessInfoAuthenticationNextEvent: PublishRelay<SignUpBusinessInfoAuthenticationViewController.AuthenticationCase> = .init(),
      email: PublishRelay<String> = .init(),
      duplicateCheckEvent: PublishRelay<Void> = .init(),
      emailNextEvent: PublishRelay<Void> = .init(),
      password: PublishRelay<String> = .init(),
      passwordCheck: PublishRelay<String> = .init(),
      passwordNextEvent: PublishRelay<Void> = .init(),
      nickname: PublishRelay<String> = .init(),
      profileNextEvent: PublishRelay<(Data?, SignUpProfileViewController.WriteProfileCase)> = .init(),
      signUpToastCompletedEvent: PublishRelay<Void> = .init(),
      updateSellerAuthorityTapEvent: PublishRelay<Void> = .init(),
      updateSellerToastCompletedEvent: PublishRelay<Void> = .init()
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
      self.updateSellerAuthorityTapEvent = updateSellerAuthorityTapEvent
      self.updateSellerToastCompletedEvent = updateSellerToastCompletedEvent
    }
  }
  
  struct Output {
    let businessInfoAuthenticationResult: Driver<Bool>
    let showAuthenticationResultToast: Driver<String>
    let duplicateCheckResult: Driver<Bool>
    let showDuplicationCheckResultToast: Driver<Void>
    let passwordEqualValidationResult: Driver<Bool>
    let signUpCompleted: Driver<String>
    let signUpFailed: Driver<Void>
    let updateSellerCompletedEvent: Driver<Void>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  private let checkEmailValidationUsecase: any CheckEmailDuplicationUsecase
  private let authenticateBusinessInfoUsecase: any AuthenticateBusinessInfoUsecase
  private let signUsecase: any SignUsecase
  private let profileUsecase: any ProfileUsecase
  
  private let email = BehaviorRelay<String>(value: "")
  private let password = BehaviorRelay<String>(value: "")
  private let nickname = BehaviorRelay<String>(value: "")
  private let businessInfoAuthenticated = BehaviorRelay<Bool>(value: false)
  
  // MARK: - Initializer
  init(
    checkEmailValidationUsecase: any CheckEmailDuplicationUsecase,
    authenticateBusinessInfoUsecase: any AuthenticateBusinessInfoUsecase,
    signUsecase: any SignUsecase,
    profileUsecase: any ProfileUsecase
  ) {
    self.checkEmailValidationUsecase = checkEmailValidationUsecase
    self.authenticateBusinessInfoUsecase = authenticateBusinessInfoUsecase
    self.signUsecase = signUsecase
    self.profileUsecase = profileUsecase
  }
  
  // MARK: - Method
  @discardableResult 
  func transform(input: Input) -> Output {
    
    let showAuthenticationResultToast = PublishRelay<String>()
    
    let duplicateCheckResult = BehaviorRelay<Bool>(value: false)
    let showDuplicationCheckResultToast = PublishRelay<Void>()
    
    let passwordEqualValidationResult = BehaviorRelay<Bool>(value: false)
    let signUpCompleted = PublishRelay<String>()
    let signUpFailed = PublishRelay<Void>()
    
    let onboardingSellerAuthorityTrigger = PublishRelay<Void>()
    let updateSellerAuthorityTrigger = PublishRelay<Void>()
    let updateSellerCompletedEvent = PublishRelay<Void>()
    
    let onboardingProfileTrigger = PublishRelay<Data?>()
    let updateProfileTrigger = PublishRelay<Data?>()
    
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
        owner.coordinator?.showSignUpBusinessInfoAuthenticationView(authenticationCase: .onboarding)
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
      .bind {
        switch $0 {
          case .onboarding:
            onboardingSellerAuthorityTrigger.accept(())
          case .updateProfile:
            updateSellerAuthorityTrigger.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    /// 회원가입 과정에서 메인 버튼 탭
    onboardingSellerAuthorityTrigger
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpEmailView()
      }
      .disposed(by: disposeBag)
    
    /// 사업자 정보 업데이트 요청
    updateSellerAuthorityTrigger
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.profileUsecase.updateSellerAuthority()
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .map { _ in () }
      .bind(to: updateSellerCompletedEvent)
      .disposed(by: disposeBag)
    
    /// 토스트 완료 후 화면 pop
    input.updateSellerToastCompletedEvent
      .bind(with: self) { owner, _ in
        UserInfoService.hasSellerAuthority = true
        owner.coordinator?.pop()
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
            return Single.just(())
          }
      }
      .bind {
        duplicateCheckResult.accept(true)
        showDuplicationCheckResultToast.accept($0)
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
    .map { $0 == $1 && $0.isFilled && $1.isFilled }
    .bind(to: passwordEqualValidationResult)
    .disposed(by: disposeBag)
    
    /// 비밀번호 다음 버튼 이벤트 화면 연결
    input.passwordNextEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpProfileView(writingProfileCase: .onboarding)
      }
      .disposed(by: disposeBag)
    
    /// 닉네임 입력내용 전달
    input.nickname
      .bind(to: nickname)
      .disposed(by: disposeBag)
    
    /// 회원가입 프로필 설정 / 업데이트 프로필 분기 처리
    input.profileNextEvent
      .bind {
        let (imageData, writingCase) = $0
        
        switch writingCase {
          case .onboarding:
            onboardingProfileTrigger.accept(imageData)
          case .update:
            updateProfileTrigger.accept(imageData)
        }
      }
      .disposed(by: disposeBag)
    
    /// 프로필 > 판매자 인증 이벤트 화면 연결
    input.updateSellerAuthorityTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showSignUpBusinessInfoAuthenticationView(authenticationCase: .updateProfile)
      }
      .disposed(by: disposeBag)
    
    /// 회원가입 -> 로그인 -> 프로필 이미지 적용
    /// 성공하면 토스트 안내 후 coordinator end, 실패하면 인디케이터 중지 output
    onboardingProfileTrigger
      .withUnretained(self)
      .flatMap { owner, imageData in
        
        return owner.signUsecase.signUp(
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
          signUpCompleted.accept("회원가입이 완료되었어요!")
        } else {
          signUpFailed.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    /// 프로필 업데이트 요청 > 완료 토스트 표시
    updateProfileTrigger
      .withUnretained(self)
      .flatMap { owner, imageData in
        return owner.profileUsecase.updateProfile(nick: owner.nickname.value, profile: imageData)
          .map { _ in true }
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .just(false)
          }
      }
      .bind { success in
        if success {
          signUpCompleted.accept("프로필 수정이 완료되었어요!")
        } else {
          signUpFailed.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    /// 토스트 표시가 완료되면 시작 화면으로 이동
    input.signUpToastCompletedEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.end()
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
    
    return Output(
      businessInfoAuthenticationResult: businessInfoAuthenticated.asDriver(),
      showAuthenticationResultToast: showAuthenticationResultToast.asDriver(onErrorJustReturn: "-"),
      duplicateCheckResult: duplicateCheckResult.asDriver(),
      showDuplicationCheckResultToast: showDuplicationCheckResultToast.asDriver(onErrorJustReturn: ()),
      passwordEqualValidationResult: passwordEqualValidationResult.asDriver(),
      signUpCompleted: signUpCompleted.asDriver(onErrorJustReturn: "-"),
      signUpFailed: signUpFailed.asDriver(onErrorJustReturn: ()),
      updateSellerCompletedEvent: updateSellerCompletedEvent.asDriver(onErrorJustReturn: ())
    )
  }
}
