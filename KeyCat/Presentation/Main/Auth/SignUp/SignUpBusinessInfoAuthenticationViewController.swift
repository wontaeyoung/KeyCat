//
//  SignUpBusinessInfoAuthenticationViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpBusinessInfoAuthenticationViewController: SignUpBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let businessNumberField = ValidationField(
    inputInformation: .businessNumber,
    type: .numberPad
  )
  
  private let authenticationButton = KCButton(
    style: .plain,
    title: Constant.Button.businessInfoAuthentication
  )
  
  // MARK: - Property
  let viewModel: SignUpViewModel
  private let authenticationCase: AuthenticationCase
  
  // MARK: - Initializer
  init(viewModel: SignUpViewModel, authenticationCase: AuthenticationCase) {
    self.viewModel = viewModel
    self.authenticationCase = authenticationCase
    
    super.init(inputInfoTitle: Constant.Label.inputBusinessInfo)
    
    if case .updateProfile = authenticationCase {
      nextButton.title("인증 완료")
    }
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    super.setHierarchy()
    
    view.addSubviews(
      businessNumberField,
      authenticationButton
    )
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    businessNumberField.snp.makeConstraints { make in
      make.top.equalTo(inputInfoTitleLabel.snp.bottom)
      make.leading.equalTo(view).inset(20)
    }
    
    authenticationButton.snp.makeConstraints { make in
      make.bottom.equalTo(businessNumberField)
      make.leading.equalTo(businessNumberField.snp.trailing).offset(10)
      make.trailing.equalTo(view).inset(20)
      make.width.equalTo(100)
    }
  }
  
  override func bind() {
    
    let input = SignUpViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 사업자 인증 완료 여부 -> 다음 버튼 활성화
    output.businessInfoAuthenticationResult
      .drive(nextButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 사업자 인증 결과 토스트 표시
    output.showAuthenticationResultToast
      .drive(with: self) { owner, message in owner.toast(message) }
      .disposed(by: disposeBag)
    
    /// 사업자 업데이트 토스트 표시
    output.updateSellerCompletedEvent
      .map { "판매자 인증이 완료되었어요!" }
      .drive(with: self) { owner, message in
        owner.toast(message) {
          input.updateSellerToastCompletedEvent.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    /// 사업자 인증 버튼 탭 -> 현재 사업자 번호 입력값 전달
    authenticationButton.rx.tap
      .buttonThrottle()
      .withLatestFrom(businessNumberField.rx.text.orEmpty)
      .bind(to: input.businessInfoAuthenticationEvent)
      .disposed(by: disposeBag)
    
    /// 다음 버튼 탭 이벤트 전달
    nextButton.rx.tap
      .buttonThrottle()
      .map { self.authenticationCase }
      .bind(to: input.businessInfoAuthenticationNextEvent)
      .disposed(by: disposeBag)
    
    /// 사업자 번호 유효성 검사 -> 사업자 인증 버튼 활성화
    businessNumberField.inputValidation
      .bind(to: authenticationButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}

extension SignUpBusinessInfoAuthenticationViewController {
  
  enum AuthenticationCase {
    
    case onboarding
    case updateProfile
  }
}
