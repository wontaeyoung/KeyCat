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
  
  private let cellType = ChatRoomTableCell.self
  private let cellIdentifier = ChatRoomTableCell.identifier
  
  // MARK: - UI
  private let searchField = KCField(placeholder: "검색")
  private lazy var chatRoomTableView = UITableView().configured {
    $0.register(cellType, forCellReuseIdentifier: cellIdentifier)
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
    
    view.addSubviews(chatRoomTableView)
  }
  
  override func setConstraint() {
    searchField.snp.makeConstraints { make in
      make.width.equalTo(200)
      make.height.equalTo(40)
    }
    
    chatRoomTableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    
    let input = ChatRoomListViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.chatRooms
      .drive(chatRoomTableView.rx.items(
        cellIdentifier: cellIdentifier,
        cellType: cellType)
      ) { row, chatRoom, cell in
        cell.setData(chatRoom: chatRoom)
      }
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
}
