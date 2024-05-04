//
//  MyProfileViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyProfileViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: MyProfileViewModel
  
  // MARK: - Initializer
  init(viewModel: MyProfileViewModel) {
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
