//
//  CreateCommercialPostViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CreateCommercialPostViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: CreateCommercialPostViewModel
  
  // MARK: - Initializer
  init(viewModel: CreateCommercialPostViewModel) {
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
  
  // MARK: - Method
  
}
