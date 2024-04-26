//
//  ShoppingViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: ShoppingViewModel
  
  // MARK: - Initializer
  init(viewModel: ShoppingViewModel) {
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
