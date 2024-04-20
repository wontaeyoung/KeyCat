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
import TextFieldEffects

final class SignUpEmailViewController: SignUpBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let emailField = SignUpInputField(inputInformation: .email)
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
    
  }
}

@available(iOS 17, *)
#Preview {
  SignUpEmailViewController(viewModel: SignUpViewModel())
}
