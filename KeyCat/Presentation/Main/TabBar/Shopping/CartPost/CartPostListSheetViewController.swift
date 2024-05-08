//
//  CartPostListSheetViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CartPostListSheetViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let postAddedInfoLabel = KCLabel(title: "장바구니에 상품을 담았어요.", font: .bold(size: 16))
  private let shortCutButton = KCButton(style: .secondary, title: "바로가기")
  private let tableView = UITableView().configured {
    $0.register(
      CartPostSheetTableCell.self,
      forCellReuseIdentifier: CartPostSheetTableCell.identifier
    )
  }
  
  // MARK: - Property
  private let cartPosts: BehaviorRelay<[CommercialPost]>
  let viewModel: CommercialPostDetailViewModel
  
  // MARK: - Initializer
  init(cartPosts: BehaviorRelay<[CommercialPost]>, viewModel: CommercialPostDetailViewModel) {
    self.cartPosts = cartPosts
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
    view.addSubviews(
      postAddedInfoLabel,
      shortCutButton,
      tableView
    )
  }
  
  override func setConstraint() {
    
    postAddedInfoLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(20)
      make.centerY.equalTo(shortCutButton)
    }
    
    shortCutButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.trailing.equalToSuperview().inset(20)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(shortCutButton.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func bind() {
    
    let input = CommercialPostDetailViewModel.Input()
    let _ = viewModel.transform(input: input)
    
    shortCutButton.rx.tap
      .buttonThrottle()
      .bind(to: input.cartShortCutTapEvent)
      .disposed(by: disposeBag)
    
    cartPosts
      .bind(to: tableView.rx.items(
        cellIdentifier: CartPostSheetTableCell.identifier,
        cellType: CartPostSheetTableCell.self)
      ) { row, item, cell in
        
        cell.setData(post: item)
      }
      .disposed(by: disposeBag)
  }
}
