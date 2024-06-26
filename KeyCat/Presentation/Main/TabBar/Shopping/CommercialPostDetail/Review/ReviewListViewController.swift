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
  private lazy var backBarButtonItem = UIBarButtonItem().configured {
    $0.image = KCAsset.Symbol.backButton
    setBarItem(at: .left, item: $0)
  }
  
  private lazy var createReviewBarButtonItem = UIBarButtonItem().configured {
    $0.title = "리뷰 쓰기"
    setBarItem(at: .right, item: $0)
  }
  
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
  
  override func bind() {
    
    let input = ReviewListViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 리뷰 리스트 > 테이블 뷰 데이터 연결
    output.reviews
      .drive(tableView.rx.items(cellIdentifier: ReviewTableCell.identifier, cellType: ReviewTableCell.self)) { row, review, cell in
        cell.setData(review: review)
        cell.selectionStyle = .none
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 셀 탭 이벤트 전달
    tableView.rx.modelSelected(CommercialReview.self)
      .bind(to: input.reviewCellTapEvent)
      .disposed(by: disposeBag)
    
    /// 커스텀 Back 버튼 탭 이벤트 전달
    backBarButtonItem.rx.tap
      .buttonThrottle()
      .bind(to: input.backTapEvent)
      .disposed(by: disposeBag)
    
    /// 리뷰 작성 버튼 탭 이벤트 전달
    createReviewBarButtonItem.rx.tap
      .buttonThrottle()
      .bind(to: input.createReviewTapEvent)
      .disposed(by: disposeBag)
  }
}
