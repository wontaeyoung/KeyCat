//
//  SignUpPasswordViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpPasswordViewController: SignUpBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let passwordField = SignUpInputField(inputInformation: .password)
  private let passwordCheckField = SignUpInputField(inputInformation: .passwordCheck)
  private lazy var passwordSecureButton = SecureButton(field: passwordField)
  private lazy var passwordCheckSecureButton = SecureButton(field: passwordCheckField)
  
  // MARK: - Property
  let viewModel: SignUpViewModel
  
  // MARK: - Initializer
  init(viewModel: SignUpViewModel) {
    self.viewModel = viewModel
    
    super.init(inputInfoTitle: Constant.Label.inputPasswordInfo)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    super.setHierarchy()
    
    view.addSubviews(
      passwordField,
      passwordCheckField,
      passwordSecureButton,
      passwordCheckSecureButton
    )
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    passwordField.snp.makeConstraints { make in
      make.top.equalTo(inputInfoTitleLabel.snp.bottom)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    passwordCheckField.snp.makeConstraints { make in
      make.top.equalTo(passwordField.snp.bottom).offset(40)
      make.horizontalEdges.equalTo(view).inset(20)
    }
    
    passwordSecureButton.snp.makeConstraints { make in
      make.trailing.equalTo(passwordField).offset(-5)
      make.bottom.equalTo(passwordField).offset(-5)
    }
    
    passwordCheckSecureButton.snp.makeConstraints { make in
      make.trailing.equalTo(passwordCheckField).offset(-5)
      make.bottom.equalTo(passwordCheckField).offset(-5)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = SignUpViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 비밀번호 일치 결과를 비밀번호 필드 유효성 옵저버블에 전달
    output.passwordEqualValidationResult
      .drive(passwordCheckField.inputValidation)
      .disposed(by: disposeBag)
    
    /// 비밀번호 정규식 + 비밀번호 일치 결과를 다음 버튼 활성화에 전달
    Observable.combineLatest(
      passwordField.inputValidation,
      output.passwordEqualValidationResult.asObservable()
    )
    .map { $0 && $1 }
    .bind(to: nextButton.rx.isEnabled)
    .disposed(by: disposeBag)
    
    /// 비밀번호 입력값 전달
    passwordField.rx.text.orEmpty
      .bind(to: input.password)
      .disposed(by: disposeBag)
    
    /// 비밀번호 확인 입력값 전달
    passwordCheckField.rx.text.orEmpty
      .bind(to: input.passwordCheck)
      .disposed(by: disposeBag)
  }
}

@available(iOS 17, *)
#Preview {
  UINavigationController(rootViewController: SignUpEmailViewController(viewModel: SignUpViewModel()))
}
