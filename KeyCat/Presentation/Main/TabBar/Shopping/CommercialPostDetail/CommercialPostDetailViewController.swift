//
//  CommercialPostDetailViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommercialPostDetailViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  // MARK: 뷰 컨테이너
  private let scrollView = UIScrollView().configured { $0.keyboardDismissMode = .onDrag }
  private let contentView = UIView()
  
  // MARK: 상품 이미지 컬렉션
  private lazy var productImageCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: compositionalLayout
  ).configured {
    $0.register(
      CommercialPostDetailImageCollectionCell.self,
      forCellWithReuseIdentifier: CommercialPostDetailImageCollectionCell.identifier
    )
    $0.showsHorizontalScrollIndicator = false
    $0.keyboardDismissMode = .onDrag
  }
  
  private var compositionalLayout = UICollectionViewCompositionalLayout(
    section: .makeCardSection(cardSpacing: 0, heightRatio: 1)
  )
  
  private let imagePageTag = TagLabel(title: nil, backgroundColor: .darkGray)
  
  // MARK: 상품 텍스트 정보
  private let titleLabel = KCLabel(font: .medium(size: 16), line: 2)
  private let reviewView = ReviewView()
  private let productPriceView = ProductPriceView()
  
  private let deliverySectionDivider = Divider()
  private let deliveryInfoView = DeliveryInfoView()
  
  private let sellerSectionDivider = Divider()
  private let sellerProfileView = SellerProfileView()
  
  // MARK: - Property
  let viewModel: CommercialPostDetailViewModel
  
  // MARK: - Initializer
  init(viewModel: CommercialPostDetailViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(scrollView)
    scrollView.addSubviews(contentView)
    contentView.addSubviews(
      productImageCollectionView,
      imagePageTag,
      titleLabel,
      reviewView,
      productPriceView,
      deliverySectionDivider,
      deliveryInfoView,
      sellerSectionDivider,
      sellerProfileView
    )
  }
  
  override func setConstraint() {
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints { make in
      make.width.equalTo(scrollView)
      make.verticalEdges.equalTo(scrollView)
    }
    
    productImageCollectionView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
      make.height.equalTo(productImageCollectionView.snp.width)
    }
    
    imagePageTag.snp.makeConstraints { make in
      make.centerX.equalTo(productImageCollectionView)
      make.bottom.equalTo(productImageCollectionView).inset(10)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(productImageCollectionView.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    reviewView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(5)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    productPriceView.snp.makeConstraints { make in
      make.top.equalTo(reviewView.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    deliverySectionDivider.snp.makeConstraints { make in
      make.top.equalTo(productPriceView.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
    }
    
    deliveryInfoView.snp.makeConstraints { make in
      make.top.equalTo(deliverySectionDivider).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    sellerSectionDivider.snp.makeConstraints { make in
      make.top.equalTo(deliveryInfoView.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
    }
    
    sellerProfileView.snp.makeConstraints { make in
      make.top.equalTo(sellerSectionDivider).offset(10)
      make.horizontalEdges.equalToSuperview().inset(20)
      make.bottom.equalToSuperview()
    }
  }
  
  override func setAttribute() {
    
  }
  
  override func bind() {
    
    let input = CommercialPostDetailViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 상품 이미지 URL로 컬렉션 뷰 표시
    output.post
      .map { $0.productImagesURL }
      .drive(productImageCollectionView.rx.items(
        cellIdentifier: CommercialPostDetailImageCollectionCell.identifier,
        cellType: CommercialPostDetailImageCollectionCell.self)
      ) { row, url, cell in
        cell.updateImage(with: url)
      }
      .disposed(by: disposeBag)
    
    /// 상품 이미지 페이지 번호 표시
    Observable.combineLatest(
      productImageCollectionView.rx.willDisplayCell.map { $0.at },
      output.post.map { $0.files.count }.asObservable()
    )
    .map { "\($0.0.item + 1) / \($0.1)"}
    .bind(to: imagePageTag.rx.text)
    .disposed(by: disposeBag)
    
    /// 상품 타이틀 표시
    output.post
      .map { $0.title }
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)
    
    /// 상품 리뷰 표시
    output.post
      .map { $0.reviews }
      .drive(reviewView.rx.reviews)
      .disposed(by: disposeBag)
    
    /// 상품 가격 표시
    output.post
      .map { $0.price }
      .drive(productPriceView.rx.productPrice)
      .disposed(by: disposeBag)
    
    /// 배송정보 표시
    output.post
      .map { $0.delivery }
      .drive(deliveryInfoView.rx.deliveryInfo)
      .disposed(by: disposeBag)
    
    output.post
      .map { $0.creator }
      .drive(sellerProfileView.rx.seller)
      .disposed(by: disposeBag)
  }
}
