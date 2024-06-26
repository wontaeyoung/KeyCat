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
  private let cartButton = BadgeButton()
  private lazy var cartBarButton = UIBarButtonItem(customView: cartButton)
  
  private let createPostFloatingButton = KCButton(
    style: .floating,
    title: "+"
  ).configured {
    $0.layer.configure {
      $0.shadowColor = KCAsset.Color.black.color.cgColor
      $0.shadowOffset = CGSize(width: 0, height: 2)
      $0.shadowOpacity = 0.5
      $0.shadowRadius = 2
    }
  }
  
  private lazy var productCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout.gridLayout(cellCount: 2, cellSpacing: 20)
  ).configured {
    $0.register(
      ProductCollectionCell.self,
      forCellWithReuseIdentifier: ProductCollectionCell.identifier
    )
    
    $0.refreshControl = refreshControl
  }
  
  private let refreshControl = UIRefreshControl()

  // MARK: - Property
  let viewModel: ShoppingViewModel
  
  // MARK: - Initializer
  init(viewModel: ShoppingViewModel) {
    self.viewModel = viewModel
    
    super.init()
    setBarItem(at: .right, item: cartBarButton)
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
  
  override func bind() {
    
    let input = ShoppingViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 판매자 등록 여부 > 판매글 작성 버튼 표시
    /* 사업자 번호가 없는 유저의 게시물 생성 테스트 환경을 위해 Hidden 처리 비활성화
    output.hasSellerAuthority
      .map { !$0 }
      .drive(createPostFloatingButton.rx.isHidden)
      .disposed(by: disposeBag)
     */
    
    /// 게시글 리스트 컬렉션 뷰에 전달
    output.posts
      .drive(productCollectionView.rx.items(
        cellIdentifier: ProductCollectionCell.identifier,
        cellType: ProductCollectionCell.self)
      ) { row, item, cell in
        cell.setData(with: item)
      }
      .disposed(by: disposeBag)
    
    /// 장바구니 상품 > 뱃지 갯수 반영
    output.cartPosts
      .map { $0.count.description }
      .drive(cartButton.rx.title)
      .disposed(by: disposeBag)
    
    /// 새로고침 로직 처리 후 애니메이션 종료
    output.refreshCompleted
      .drive(with: self) { owner, _ in
        owner.refreshControl.endRefreshing()
      }
      .disposed(by: disposeBag)
    
    /// 컬렉션 뷰 탭 이벤트 전달
    productCollectionView.rx.modelSelected(CommercialPost.self)
      .bind(to: input.postCollectionCellSelectedEvent)
      .disposed(by: disposeBag)
    
    /// 셀 화면 표시 이벤트 전달
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
    
    /// 장바구니 버튼 탭 이벤트 전달
    cartButton.tap
      .bind(to: input.cartTapEvent)
      .disposed(by: disposeBag)
    
    /// 새로고침 이벤트 전달
    refreshControl.rx.controlEvent(.valueChanged)
      .bind(to: input.scrollRefeshEvent)
      .disposed(by: disposeBag)
    
    input.viewDidLoadEvent.accept(())
  }
}
