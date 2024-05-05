//
//  FollowListViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowListViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let tableView = UITableView().configured {
    $0.register(FollowTableCell.self, forCellReuseIdentifier: FollowTableCell.identifier)
  }
  
  // MARK: - Property
  let viewModel: FollowListViewModel
  private let followTab: FollowTabmanViewController.FollowTab
  
  // MARK: - Initializer
  init(viewModel: FollowListViewModel, followTab: FollowTabmanViewController.FollowTab) {
    self.viewModel = viewModel
    self.followTab = followTab
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      tableView
    )
  }
  
  override func setConstraint() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
   
    let input = FollowListViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 프로필 셀 연결
    output.profile
      .map { self.followTab == .following ? $0.folllowing : $0.followers }
      .drive(tableView.rx.items(
        cellIdentifier: FollowTableCell.identifier, 
        cellType: FollowTableCell.self)
      ) { row, user, cell in
        cell.setData(follow: user)
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
  }
}
