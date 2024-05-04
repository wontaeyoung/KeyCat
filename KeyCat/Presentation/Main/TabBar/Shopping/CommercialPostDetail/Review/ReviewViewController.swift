//
//  ReviewViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ReviewViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: ReviewViewModel
  
  // MARK: - Initializer
  init(viewModel: ReviewViewModel) {
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
