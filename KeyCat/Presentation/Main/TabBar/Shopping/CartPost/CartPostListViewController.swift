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
  private let tableView = UITableView().configured {
    $0.register(CartPostTableCell.self, forCellReuseIdentifier: CartPostTableCell.identifier)
  }
  
  // MARK: - Property
  let viewModel: CartPostListViewModel
  
  // MARK: - Initializer
  init(viewModel: CartPostListViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(tableView)
  }
  
  override func setConstraint() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = CartPostListViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 장바구니 게시물 리스트로 테이블 그리기
    output.posts
      .drive(tableView.rx.items(
        cellIdentifier: CartPostTableCell.identifier,
        cellType: CartPostTableCell.self)
      ) { row, post, cell in
        cell.setData(post: post)
      }
      .disposed(by: disposeBag)
  }
}
