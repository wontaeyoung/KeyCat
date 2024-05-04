//
//  CreateCommercialReviewViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CreateCommercialReviewViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private let containerView = UIView()
  private let productImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFill
    
    $0.layer.configure {
      $0.cornerRadius = 10
      $0.borderColor = KCAsset.Color.lightGrayForeground.color.cgColor
      $0.borderWidth = 1
    }
  }
  private let productTitleLabel = KCLabel(font: .medium(size: 14), line: 2)
  private let starStack = UIStackView().configured {
    $0.axis = .horizontal
    $0.spacing = 2
  }
  
  private lazy var starButtons: [KCButton] = CommercialReview.Rating.allCases.map { rating in
    return KCButton(style: .icon, image: KCAsset.Symbol.emptyReviewScore).configured {
      $0.rx.tap
        .buttonThrottle(seconds: 1)
        .map { rating }
        .bind(to: reviewRating)
        .disposed(by: disposeBag)
      
      $0.snp.makeConstraints { make in
        make.size.equalTo(30)
      }
      
      starStack.addArrangedSubview($0)
    }
  }
  
  private let reviewTitleLabel = KCLabel(
    title: "리뷰 내용",
    font: .bold(size: 14),
    color: .darkGray
  )
  private let reviewMinimumLengthInfoLabel = KCLabel(
    title: "리뷰는 최소 \(BusinessValue.Product.minReviewContentLength)자 이상 작성해주세요",
    font: .medium(size: 13),
    color: .lightGrayForeground,
    alignment: .right
  )
  private let contentTextView = KCTextView(
    placeholder: "사용해보고 느낀 점을 알려주세요",
    maxLength: BusinessValue.Product.maxContentLength
  )
  
  private let createButton = KCButton(style: .primary, title: "다 썼어요")
  
  // MARK: - Property
  let viewModel: CreateCommercialReviewViewModel
  private let reviewRating = PublishRelay<CommercialReview.Rating>()
  
  // MARK: - Initializer
  init(viewModel: CreateCommercialReviewViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(containerView)
    
    containerView.addSubviews(
      productImageView,
      productTitleLabel,
      starStack,
      reviewTitleLabel,
      reviewMinimumLengthInfoLabel,
      contentTextView,
      createButton
    )
  }
  
  override func setConstraint() {
    containerView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
    
    productImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.size.equalTo(60)
    }
    
    productTitleLabel.snp.makeConstraints { make in
      make.leading.equalTo(productImageView.snp.trailing).offset(10)
      make.centerY.equalTo(productImageView)
      make.trailing.equalToSuperview()
    }
    
    starStack.snp.makeConstraints { make in
      make.top.equalTo(productImageView.snp.bottom).offset(20)
      make.leading.equalToSuperview()
    }
    
    reviewTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(starStack.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
    }
    
    reviewMinimumLengthInfoLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.bottom.equalTo(reviewTitleLabel)
    }
    
    contentTextView.snp.makeConstraints { make in
      make.top.equalTo(reviewTitleLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview()
    }
    
    createButton.snp.makeConstraints { make in
      make.top.equalTo(contentTextView.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  override func bind() {
    
    let input = CreateCommercialReviewViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 상품 이미지 표시
    output.post
      .compactMap { $0.productImagesURL.first }
      .drive(with: self) { owner, url in
        owner.productImageView.load(with: url)
      }
      .disposed(by: disposeBag)
    
    /// 상품 제목 표시
    output.post
      .map { $0.title }
      .drive(productTitleLabel.rx.text)
      .disposed(by: disposeBag)
    
    /// 리뷰 점수 변경 > 리뷰 별점 UI 반영
    output.reviewRating
      .drive(with: self) { owner, rating in
        owner.updateStarStack(with: rating)
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 내용 유효성 검사 > 작성 버튼 활성화
    output.createButtonEnable
      .drive(createButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    /// 리뷰 점수 변경 이벤트 전달
    reviewRating
      .bind(to: input.reviewRating)
      .disposed(by: disposeBag)
    
    /// 리뷰 텍스트 입력 전달
    contentTextView.rx.text.orEmpty
      .bind(to: input.content)
      .disposed(by: disposeBag)
    
    /// 작성하기 버튼 이벤트 전달
    createButton.rx.tap
      .buttonThrottle()
      .bind(to: input.createTapEvent)
      .disposed(by: disposeBag)
  }
  
  private func updateStarStack(with currentRating: CommercialReview.Rating) {
    CommercialReview.Rating.allCases.enumerated().forEach { index, rating in
      let image = currentRating.rawValue >= rating.rawValue
      ? KCAsset.Symbol.reviewScore
      : KCAsset.Symbol.emptyReviewScore
      
      starButtons[index].image(image)
    }
  }
}
