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
  
  private let keyboardSectionDivider = Divider()
  private let keyboardInfoView = KeyboardInfoView()
  
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
      sellerProfileView,
      keyboardSectionDivider,
      keyboardInfoView
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
    }
    
    keyboardSectionDivider.snp.makeConstraints { make in
      make.top.equalTo(sellerProfileView.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
    }
    
    keyboardInfoView.snp.makeConstraints { make in
      make.top.equalTo(keyboardSectionDivider).offset(10)
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
  }
}

@available(iOS 17.0, *)
#Preview {
  let post = CommercialPost(
    postID: "66328622ea1f6976de7e36d8",
    postType: .keycat_commercialProduct,
    title: "로지텍 코리아 MX MECHANICAL MIN for mac 블루투스 기계식 키보드",
    content: "맥 전용 키 레이아웃을 갖춰 기존에 애플 디바이스 사용자는 별도의 적응 시간 없이 사용할 수 있고, 맥 전용 제품인 만큼 맥북, 아이폰, 아이패드와 뛰어난 호환성을 자랑한다. 디자인 측면에서도 맥 전용 페일 그레이 컬러로 출시되어 맥 제품군과 어울린다. 멀티태스킹 성능 또한 뛰어나다. 이지 스위치 기능을 통해 최대 3개의 기기와 동시에 페어링한 후, 버튼을 눌러 전환하며 사용할 수 있고, 로지텍 플로우 기능 또한 지원해 서로 다른 OS의 기기를 마치 하나의 OS에서 사용하는 것처럼 자연스럽게 넘나들며 업무를 진행할 수 있다.",
    keyboard: .init(
      keyboardInfo: .init(
        purpose: .allCases.randomElement()!,
        inputMechanism: .allCases.randomElement()!,
        connectionType: .allCases.randomElement()!,
        powerSource: .allCases.randomElement()!,
        backlight: .allCases.randomElement()!,
        pcbType: .allCases.randomElement()!,
        mechanicalSwitch: .allCases.randomElement()!,
        capacitiveSwitch: .allCases.randomElement()!
      ),
      keycapInfo: .init(
        profile: .allCases.randomElement()!,
        direction: .allCases.randomElement()!,
        process: .allCases.randomElement()!,
        language: .allCases.randomElement()!
      ),
      keyboardAppearanceInfo: .init(
        ratio: .allCases.randomElement()!,
        design: .allCases.randomElement()!,
        material: .allCases.randomElement()!,
        size: .init(width: 380, height: 150, depth: 40, weight: 1062)
      )
    ),
    price: .init(
      regularPrice: 229000,
      couponPrice: 2000,
      discountPrice: 149000,
      discountExpiryDate: DateManager.shared.date(from: .now, as: .day, by: 5)
    ),
    delivery: .init(
      price: .allCases.randomElement()!,
      schedule: .allCases.randomElement()!
    ),
    createdAt: .now,
    creator: .init(
      userID: "662a499ea8bf9f5c9ca667a8",
      nickname: "qaz",
      profileImageURLString: "uploads/profiles/1714047391048.jpg"
    ),
    files: [
      "uploads/posts/keyboard1_1714639591607.jpg",
      "uploads/posts/keyboard2_1714639591628.jpg",
      "uploads/posts/keyboard3_1714639591630.png"
    ],
    likes: [["662a499ea8bf9f5c9ca667a8"], []].randomElement()!,
    shoppingCarts: [["662a499ea8bf9f5c9ca667a8"], []].randomElement()!,
    hashTags: [],
    reviews: CommercialPost.dummyReviews
  )
  
  let vm = CommercialPostDetailViewModel(post: post)
  let vc = CommercialPostDetailViewController(viewModel: vm)
  return UINavigationController(rootViewController: vc)
}
