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
  }
  
  struct Output {
    let duplicateCheckResult: Driver<Bool>
    let showDuplicationCheckResultToast: Driver<Void>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: AuthCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  private let checkEmailValidationUsecase: CheckEmailDuplicationUsecase = CheckEmailDuplicationUsecaseImpl()
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let emailChanged = BehaviorRelay(value: ())
    let duplicateCheckResult = BehaviorRelay<Bool>(value: false)
    let showDuplicationCheckResultToast = PublishRelay<Void>()
    
    /// 이메일이 변경되면 중복체크 결과 초기화
    emailChanged
      .map { false }
      .bind(to: duplicateCheckResult)
      .disposed(by: disposeBag)
    
    /// 이메일 변경 이벤트 전달
    input.email
      .map { _ in () }
      .bind(to: emailChanged)
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

    
    return Output(
      duplicateCheckResult: duplicateCheckResult.asDriver(),
      showDuplicationCheckResultToast: showDuplicationCheckResultToast.asDriver(onErrorJustReturn: ())
    )
  }
}
