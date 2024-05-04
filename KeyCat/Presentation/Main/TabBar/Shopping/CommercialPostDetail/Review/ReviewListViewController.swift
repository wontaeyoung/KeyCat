//
//  ReviewListViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ReviewListViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let tableView = UITableView().configured {
    $0.register(ReviewTableCell.self, forCellReuseIdentifier: ReviewTableCell.identifier)
  }
  
  // MARK: - Property
  let viewModel: ReviewListViewModel
  
  // MARK: - Initializer
  init(viewModel: ReviewListViewModel) {
    self.viewModel = viewModel
    
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
    
    let input = ReviewListViewModel.Input()
    let output = viewModel.transform(input: input)
    
    output.reviews
      .drive(tableView.rx.items(cellIdentifier: ReviewTableCell.identifier, cellType: ReviewTableCell.self)) { row, review, cell in
        cell.setData(review: review)
      }
      .disposed(by: disposeBag)
  }
}

@available(iOS 17.0, *)
#Preview {
  let vm = ReviewListViewModel()
  let vc = ReviewListViewController(viewModel: vm)
  return UINavigationController(rootViewController: vc)
}


