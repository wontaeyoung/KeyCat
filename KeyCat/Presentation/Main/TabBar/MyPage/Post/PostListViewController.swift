//
//  PostListViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostListViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let tableView = UITableView().configured {
    $0.register(ProductTableCell.self, forCellReuseIdentifier: ProductTableCell.identifier)
  }
  
  // MARK: - Property
  let viewModel: PostListViewModel
  
  // MARK: - Initializer
  init(viewModel: PostListViewModel) {
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
  
  override func bind() {
    
    let input = PostListViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 상품 게시글 정보 테이블 표시
    output.posts
      .drive(tableView.rx.items(
        cellIdentifier: ProductTableCell.identifier,
        cellType: ProductTableCell.self)
      ) { row, post, cell in
        
        cell.setData(post: post)
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    
    /// 셀 화면 표시 이벤트 전달
    tableView.rx.willDisplayCell
      .showingCellThrottle()
      .map { $0.indexPath }
      .distinctUntilChanged()
      .bind(to: input.showProductCellEvent)
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvnet.accept(())
  }
}
