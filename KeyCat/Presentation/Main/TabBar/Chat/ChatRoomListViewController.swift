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
  private let searchField = KCField(placeholder: "검색")
  private lazy var chatRoomTableView = UITableView().configured {
    $0.register(ChatRoomTableCell.self, forCellReuseIdentifier: ChatRoomTableCell.identifier)
    $0.keyboardDismissMode = .onDrag
  }
  
  // MARK: - Property
  let viewModel: ChatRoomListViewModel
  
  // MARK: - Initializer
  init(viewModel: ChatRoomListViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    navigationItem.titleView = searchField
  }
  
  override func setConstraint() {
    chatRoomTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    
  }
}
