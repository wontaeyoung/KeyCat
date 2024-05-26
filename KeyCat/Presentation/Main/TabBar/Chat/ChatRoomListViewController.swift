//
//  ChatRoomListViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatRoomListViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  
  
  // MARK: - Property
  let viewModel: ChatRoomListViewModel
  
  // MARK: - Initializer
  init(viewModel: ChatRoomListViewModel) {
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
