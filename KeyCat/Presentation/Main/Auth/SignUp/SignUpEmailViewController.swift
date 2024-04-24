//
//  SignUpEmailViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpEmailViewController: SignUpBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let emailField = SignUpInputField(inputInformation: .email, type: .emailAddress)
  
  private let duplicateCheckButton = KCButton(style: .plain, title: Constant.Button.duplicateCheck)
  
  // MARK: - Property
  let viewModel: SignUpViewModel
  
  // MARK: - Initializer
  init(viewModel: SignUpViewModel) {
    self.viewModel = viewModel
    
    super.init(inputInfoTitle: Constant.Label.inputEmailInfo)
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    super.setHierarchy()
    
    view.addSubviews(
      emailField,
      duplicateCheckButton
    )
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    emailField.snp.makeConstraints { make in
      make.top.equalTo(inputInfoTitleLabel.snp.bottom)
      make.leading.equalTo(view).inset(20)
    }
    
    duplicateCheckButton.snp.makeConstraints { make in
      make.leading.equalTo(emailField.snp.trailing).offset(10)
      make.trailing.equalTo(view).inset(20)
      make.bottom.equalTo(emailField)
      make.width.equalTo(80)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = SignUpViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 중복체크 결과 > 다음 버튼 활성화 여부
    output.duplicateCheckResult
      .drive(nextButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 중복체크 결과 > 다음 버튼 타이틀 업데이트
    output.duplicateCheckResult
      .map { $0 ? Constant.Button.next : Constant.Button.duplicateCheckInfo }
      .drive(nextButton.rx.title())
      .disposed(by: disposeBag)
    
    /// 중복체크 결과 > 사용자 안내
    output.showDuplicationCheckResultToast
      .withLatestFrom(output.duplicateCheckResult)
      .map { $0 ? Constant.Label.avaliableEmailInfo : Constant.Label.duplicatedEmailInfo }
      .drive(with: self) { owner, message in owner.toast(message) }
      .disposed(by: disposeBag)
    
    /// 이메일 필드 유효성 검사 > 중복 확인 버튼 활성화 여부
    emailField.inputValidation
      .bind(to: duplicateCheckButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 중복확인 버튼 탭 이벤트 전달
    duplicateCheckButton.rx.tap
      .buttonThrottle()
      .bind(to: input.duplicateCheckEvent)
      .disposed(by: disposeBag)
    
    /// 이메일 필드 값 전달
    emailField.rx.text.orEmpty
      .bind(to: input.email)
      .disposed(by: disposeBag)
    
    /// 다음 버튼 탭 이벤트 전달
    nextButton.rx.tap
      .buttonThrottle()
      .bind(to: input.emailNextEvent)
      .disposed(by: disposeBag)
  }
}

@available(iOS 17, *)
#Preview {
  UINavigationController(rootViewController: SignUpEmailViewController(viewModel: SignUpViewModel()))
}
