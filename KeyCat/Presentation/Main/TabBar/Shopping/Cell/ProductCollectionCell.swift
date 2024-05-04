//
//  ProductCollectionCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ProductCollectionCell: RxBaseCollectionViewCell {
  
  // MARK: - UI
  private let imageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.configure {
      $0.cornerRadius = 10
      $0.borderColor = KCAsset.Color.lightGrayBackground.color.cgColor
      $0.borderWidth = 1
    }
    $0.backgroundColor = .systemBlue
  }
  
  private let titleLabel = KCLabel(font: .medium(size: 15), line: 2)
  private let productPriceView = ProductPriceView()
  private let cardDiscountTag = TagLabel(title: nil, color: .black, backgroundColor: .white).configured {
    $0.isHidden = true
  }
  private let reviewView = ReviewView()
  private lazy var tagStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 5
  }

  private let specialPriceTag = TagLabel(title: "특가", backgroundColor: .pastelRed)
  private let freeDeliveryTag = TagLabel(title: DeliveryInfo.Price.free.name, backgroundColor: .pastelBlue)
  private let deliveryScheduleTag = TagLabel(title: nil, backgroundColor: .pastelGreen)
  
  // MARK: - Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    tagStack.removeAllArrangedSubviews()
  }
  
  override func setHierarchy() {
    contentView.addSubviews(
      imageView,
      titleLabel,
      productPriceView,
      reviewView,
      tagStack,
      cardDiscountTag
    )
  }
  
  override func setConstraint() {
    imageView.snp.makeConstraints { make in
      make.top.equalTo(contentView)
      make.horizontalEdges.equalTo(contentView)
      make.height.equalTo(imageView.snp.width)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(contentView)
    }
    
    productPriceView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.horizontalEdges.equalTo(contentView)
    }
    
    reviewView.snp.makeConstraints { make in
      make.top.equalTo(productPriceView.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(contentView)
    }
    
    tagStack.snp.makeConstraints { make in
      make.top.equalTo(reviewView.snp.bottom).offset(10)
      make.leading.equalTo(contentView)
    }
    
    cardDiscountTag.snp.makeConstraints { make in
      make.top.equalTo(tagStack.snp.bottom).offset(5)
      make.leading.equalTo(contentView)
    }
  }
  
  func setData(with post: CommercialPost) {
  
    let post = post.applied { $0.reviews = CommercialPost.dummyReviews }
    
    let productImageURL = post.productImagesURL
      .compactMap { $0 }
      .first
    
    imageView.load(with: productImageURL)
    titleLabel.text = post.title
    
    productPriceView.setData(price: post.price)
    reviewView.setData(reviews: post.reviews)
    updateTags(with: post)
    
    if .random() {
      cardDiscountTag.text = "\((2...10).randomElement() ?? 5)% 카드 결제할인"
      cardDiscountTag.isHidden = false
    }
  }
  
  private func updateTags(with post: CommercialPost) {
    if post.price.discountRatio >= BusinessValue.Product.specialPriceRatio { tagStack.addArrangedSubview(specialPriceTag) }
    if post.delivery.price == .free { tagStack.addArrangedSubview(freeDeliveryTag) }
    if post.delivery.schedule != .standard {
      deliveryScheduleTag.text = post.delivery.schedule.name
      tagStack.addArrangedSubview(deliveryScheduleTag)
    }
  }
}
