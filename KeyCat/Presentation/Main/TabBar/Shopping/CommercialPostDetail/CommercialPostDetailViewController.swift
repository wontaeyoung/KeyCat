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

enum HandleContentAction: String, CaseIterable {
  
  case update = "수정"
  case delete = "삭제"
  
  var title: String {
    return self.rawValue
  }
  
  var image: UIImage? {
    switch self {
      case .update:
        return KCAsset.Symbol.update
      case .delete:
        return KCAsset.Symbol.delete
    }
  }
}

final class CommercialPostDetailViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var menuBarItem = UIBarButtonItem(image: KCAsset.Symbol.menuBarItem).configured {
    let actions = HandleContentAction.allCases
      .map { action in
        return UIAction(
          title: action.title,
          image: action.image,
          attributes: action == .delete ? .destructive : []
        ) { _ in
          self.handlePostAction.accept(action)
        }
      }
    
    $0.menu = UIMenu(title: "게시물 변경", children: actions)
  }
  
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
  
  // MARK: 상품 기본 정보
  private let titleLabel = KCLabel(font: .medium(size: 16), line: 2)
  private let reviewView = ReviewView()
  private let productPriceView = ProductPriceView()
  
  // MARK: 배송 정보
  private let deliverySectionDivider = Divider()
  private let deliveryInfoView = DeliveryInfoView()
  
  // MARK: 판매자 정보
  private let sellerSectionDivider = Divider()
  private let sellerProfileView = SellerProfileView()
  
  // MARK: 키보드 정보
  private let keyboardSectionDivider = Divider()
  private let keyboardInfoView = KeyboardInfoView()
  
  // MARK: 상품 설명 텍스트
  private let contentSectionDivider = Divider()
  private let contentSectionLabel = KCLabel(title: "상품 설명", font: .bold(size: 15), color: .darkGray)
  private let contentLabel = KCLabel(font: .medium(size: 14), line: 0, isUpdatingLineSpacing: true)
  
  // MARK: 하단 버튼 영역
  private let buttonSectionView = UIView()
  private let bookmarkButton = KCButton(style: .iconWithText)
  private let reviewButton = KCButton(style: .iconWithText, image: KCAsset.Symbol.review)
  private let addCartButton = KCButton(style: .secondary, title: "장바구니")
  private let buyingButton = KCButton(style: .primary, title: "구매하기")
  
  // MARK: - Property
  let viewModel: CommercialPostDetailViewModel
  private let handlePostAction = PublishRelay<HandleContentAction>()
  
  // MARK: - Initializer
  init(viewModel: CommercialPostDetailViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(
      scrollView,
      buttonSectionView
    )
    
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
      sellerProfileView,
      keyboardSectionDivider,
      keyboardInfoView,
      contentSectionDivider,
      contentSectionLabel,
      contentLabel
    )
    
    buttonSectionView.addSubviews(
      bookmarkButton,
      reviewButton,
      addCartButton,
      buyingButton
    )
  }
  
  override func setConstraint() {
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(buttonSectionView.snp.top).offset(-20)
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
      make.top.equalTo(deliverySectionDivider).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    sellerSectionDivider.snp.makeConstraints { make in
      make.top.equalTo(deliveryInfoView.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview()
    }
    
    sellerProfileView.snp.makeConstraints { make in
      make.top.equalTo(sellerSectionDivider).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    keyboardSectionDivider.snp.makeConstraints { make in
      make.top.equalTo(sellerProfileView.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview()
    }
    
    keyboardInfoView.snp.makeConstraints { make in
      make.top.equalTo(keyboardSectionDivider).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    contentSectionDivider.snp.makeConstraints { make in
      make.top.equalTo(keyboardInfoView.snp.bottom).offset(40)
      make.horizontalEdges.equalToSuperview()
    }
    
    contentSectionLabel.snp.makeConstraints { make in
      make.top.equalTo(contentSectionDivider).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(contentSectionLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview().inset(20)
      make.bottom.equalToSuperview()
    }
    
    buttonSectionView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(buyingButton)
    }
    
    bookmarkButton.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    reviewButton.snp.makeConstraints { make in
      make.leading.equalTo(bookmarkButton.snp.trailing)
      make.centerY.equalToSuperview()
    }
    
    addCartButton.snp.makeConstraints { make in
      make.leading.equalTo(reviewButton.snp.trailing)
      make.centerY.equalToSuperview()
    }
    
    buyingButton.snp.makeConstraints { make in
      make.leading.equalTo(addCartButton.snp.trailing).offset(10)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
      make.width.equalTo(addCartButton)
    }
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
    
    /// 배송 정보 표시
    output.post
      .map { $0.delivery }
      .drive(deliveryInfoView.rx.deliveryInfo)
      .disposed(by: disposeBag)
    
    /// 판매자 정보 표시
    output.post
      .map { $0.creator }
      .drive(sellerProfileView.rx.seller)
      .disposed(by: disposeBag)
    
    /// 키보드 정보 표시
    output.post
      .map { $0.keyboard }
      .drive(keyboardInfoView.rx.keyboard)
      .disposed(by: disposeBag)
    
    /// 상품 설명 표시
    output.post
      .map { $0.content }
      .drive(contentLabel.rx.text)
      .disposed(by: disposeBag)
    
    /// 게시물 작성자인 경우에만 변경 메뉴 추가
    output.post
      .map { $0.isCreatedByMe }
      .drive(with: self) { owner, isCreatedByMe in
        if isCreatedByMe {
          owner.navigationItem.setRightBarButton(owner.menuBarItem, animated: true)
        }
      }
      .disposed(by: disposeBag)
    
    /// 북마크 이미지 표시
    output.post
      .map { $0.isBookmarked }
      .map { $0 ? KCAsset.Symbol.bookmarkOn : KCAsset.Symbol.bookmarkOff }
      .drive(bookmarkButton.rx.image())
      .disposed(by: disposeBag)
    
    /// 북마크 갯수 표시
    output.post
      .map { $0.bookmarks.count.description }
      .drive(bookmarkButton.rx.title())
      .disposed(by: disposeBag)
      
    /// 리뷰 갯수 표시
    output.post
      .map { $0.reviews.count.description }
      .drive(reviewButton.rx.title())
      .disposed(by: disposeBag)
    
    /// 장바구니 결과 메세지 토스트 표시
    output.addCartResultToast
      .drive(with: self) { owner, message in
        owner.toast(message)
      }
      .disposed(by: disposeBag)
    
    /// 게시물 변경 액션 이벤트 전달
    handlePostAction
      .bind(to: input.handlePostAction)
      .disposed(by: disposeBag)
    
    /// 북마크 탭 이벤트 전달
    bookmarkButton.rx.tap
      .buttonThrottle()
      .bind(to: input.bookmarkTapEvent)
      .disposed(by: disposeBag)
    
    /// 리뷰 탭 이벤트 전달
    reviewButton.rx.tap
      .buttonThrottle()
      .bind(to: input.reviewTapEvent)
      .disposed(by: disposeBag)
    
    /// 장바구니 탭 이벤트 전달
    addCartButton.rx.tap
      .buttonThrottle()
      .bind(to: input.addCartTapEvent)
      .disposed(by: disposeBag)
    
  }
}
