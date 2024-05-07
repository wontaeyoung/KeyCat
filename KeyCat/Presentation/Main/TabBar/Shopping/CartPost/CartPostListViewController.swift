//
//  CartPostListViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CartPostListViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: CartPostListViewModel
  
  // MARK: - Initializer
  init(viewModel: CartPostListViewModel) {
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
