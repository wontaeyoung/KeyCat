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
  private let handleCheckboxView = UIView()
  private let toggleAllCheckboxButton = CheckboxButton()
  private let removeCheckedPostsButton = KCButton(style: .plain, title: "선택 상품 삭제")
  private let checkboxViewDivider = Divider()
  
  private let tableView = UITableView().configured {
    $0.register(CartPostTableCell.self, forCellReuseIdentifier: CartPostTableCell.identifier)
  }
  
  private let payBottomInfoView = UIView()
  private let totalPriceLabel = KCLabel(title: "0원", font: .bold(size: 15)).configured {
    $0.setContentHuggingPriority(.required, for: .horizontal)
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
  private let payButton = KCButton(style: .primary, title: "구매하기")
  
  // MARK: - Property
  let viewModel: CartPostListViewModel
  
  // MARK: - Initializer
  init(viewModel: CartPostListViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
    view.addSubviews(
      handleCheckboxView,
      tableView,
      payBottomInfoView
    )
    
    handleCheckboxView.addSubviews(
      toggleAllCheckboxButton,
      removeCheckedPostsButton,
      checkboxViewDivider
    )
    
    payBottomInfoView.addSubviews(
      totalPriceLabel,
      payButton
    )
  }
  
  override func setConstraint() {
    
    handleCheckboxView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalToSuperview().inset(10)
    }
    
    toggleAllCheckboxButton.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(5)
      make.leading.equalToSuperview()
      make.size.equalTo(25)
      make.trailing.lessThanOrEqualTo(removeCheckedPostsButton.snp.leading)
    }
    
    removeCheckedPostsButton.snp.makeConstraints { make in
      make.centerY.equalTo(toggleAllCheckboxButton)
      make.trailing.equalToSuperview()
    }
    
    checkboxViewDivider.snp.makeConstraints { make in
      make.horizontalEdges.equalTo(view)
      make.bottom.equalToSuperview()
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(handleCheckboxView.snp.bottom)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(payBottomInfoView.snp.top)
    }
    
    payBottomInfoView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    totalPriceLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalTo(payButton)
    }
    
    payButton.snp.makeConstraints { make in
      make.leading.equalTo(totalPriceLabel.snp.trailing).offset(10)
      make.verticalEdges.equalToSuperview().inset(5)
      make.trailing.equalToSuperview()
    }
  }
  
  override func bind() {
    
    let input = CartPostListViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 장바구니 게시물 리스트 + 체크박스 리스트를 조합해서 테이블 그리기
    Observable.combineLatest(
      output.cartPosts,
      output.checkStateList
    )
    .do(onNext: {
      // 전체 상품이 선택 상태면 체크박스 업데이트
      self.toggleAllCheckboxButton.isOn.accept($0.0.count == $0.1.count)
    })
    .map { posts, checkStateList in
      return posts.map { ($0, checkStateList) }
    }
    .bind(to: tableView.rx.items(
      cellIdentifier: CartPostTableCell.identifier,
      cellType: CartPostTableCell.self)
    ) { row, item, cell in
      
      let (post, checkStateList) = item
      
      cell.setData(post: post, checkStateList: checkStateList)
      
      cell.checkAction = {
        input.checkboxTapEvent.accept(post.postID)
      }
      
      cell.deleteAction = {
        input.deleteTapEvent.accept(post.postID)
      }
    }
    .disposed(by: disposeBag)
    
    /// 체크된 상품이 없으면 구매 버튼 비활성화
    output.checkStateList
      .map { $0.isFilled }
      .bind(to: payButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 체크된 상품 가격 총합을 라벨에 전달
    output.totalPrice
      .map { "\($0.formatted())원" }
      .drive(totalPriceLabel.rx.text)
      .disposed(by: disposeBag)
    
    /// 전체 체크 버튼 탭 이벤트 전달
    toggleAllCheckboxButton.rx.tap
      .bind(to: input.toggleAllCheckboxTapEvent)
      .disposed(by: disposeBag)
    
    /// 선택 삭제 버튼 탭 이벤트 전달
    removeCheckedPostsButton.rx.tap
      .bind(to: input.deleteCheckPostsTapEvent)
      .disposed(by: disposeBag)
    
    /// 장바구니 결제 사용 불가 안내 토스트
    payButton.rx.tap
      .buttonThrottle()
      .bind(with: self) { owner, _ in
        owner.toast("장바구니 결제는 현재 버전에서는 사용이 어려워요.")
      }
      .disposed(by: disposeBag)
  }
}
