//
//  ShoppingViewController.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let createPostFloatingButton = KCButton(
    style: .floating,
    title: "+"
  ).configured {
    $0.layer.configure {
      $0.shadowColor = KCAsset.Color.black.cgColor
      $0.shadowOffset = CGSize(width: 0, height: 2)
      $0.shadowOpacity = 0.5
      $0.shadowRadius = 2
    }
  }
  
  private let productCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout.gridLayout(cellCount: 2, cellSpacing: 20)
  ).configured {
    $0.register(
      ProductCollectionCell.self,
      forCellWithReuseIdentifier: ProductCollectionCell.identifier
    )
  }
  
  // MARK: - Property
  let viewModel: ShoppingViewModel
  
  // MARK: - Initializer
  init(viewModel: ShoppingViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      productCollectionView,
      createPostFloatingButton
    )
  }
  
  override func setConstraint() {
    createPostFloatingButton.snp.makeConstraints { make in
      make.trailing.equalTo(view).inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
      make.size.equalTo(50)
    }
    
    productCollectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = ShoppingViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 판매자 등록 여부 > 판매글 작성 버튼 표시
    output.hasSellerAuthority
      .map { !$0 }
      .drive(createPostFloatingButton.rx.isHidden)
      .disposed(by: disposeBag)
    
    /// 게시글 리스트 컬렉션 뷰에 전달
    output.commercialPosts
      .drive(productCollectionView.rx.items(
        cellIdentifier: ProductCollectionCell.identifier,
        cellType: ProductCollectionCell.self)
      ) { row, item, cell in
        cell.setData(with: item)
      }
      .disposed(by: disposeBag)
    
    
    productCollectionView.rx.willDisplayCell
      .showingCellThrottle()
      .map { $0.at }
      .distinctUntilChanged()
      .bind(to: input.showProductCellEvent)
      .disposed(by: disposeBag)
    
    /// 판매글 작성 버튼 탭 이벤트 전달
    createPostFloatingButton.rx.tap
      .buttonThrottle()
      .bind(to: input.createPostTapEvent)
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
  
  // MARK: - Method
  
}
