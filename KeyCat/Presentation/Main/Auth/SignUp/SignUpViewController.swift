//
//  SignUpViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import TextFieldEffects

final class SignUpViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: SignUpViewModel
  
  // MARK: - Initializer
  init(viewModel: SignUpViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
  }
  
  override func setConstraint() {
    
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
  }
}
