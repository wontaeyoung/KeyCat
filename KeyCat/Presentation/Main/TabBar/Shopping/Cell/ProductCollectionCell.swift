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
    $0.isUserInteractionEnabled = true
    $0.layer.configure {
      $0.cornerRadius = 10
      $0.borderColor = KCAsset.Color.lightGrayBackground.cgColor
      $0.borderWidth = 1
    }
    $0.backgroundColor = .systemBlue
  }
  
  private let titleLabel = KCLabel(style: .productCellTitle)
  private let discountRatioLabel = KCLabel(style: .productCellPrice)
  private let regularPriceLabel = KCLabel(style: .productCellPrice)
  private let discountPriceLabel = KCLabel(style: .productCellTitle)
  private let reviewView = ReviewView()
  private lazy var tagStack = UIStackView().configured {
    $0.axis = .vertical
    $0.spacing = 5
  }

  private let specialPriceTag = TagLabel(
    style: .tag,
    title: "특가",
    backgroundColor: KCAsset.Color.pastelRed
  )
  
  private let freeDeliveryTag = TagLabel(
    style: .tag,
    title: DeliveryInfo.Price.free.name,
    backgroundColor: KCAsset.Color.pastelBlue
  )
  
  private let deliveryScheduleTag = TagLabel(
    style: .tag,
    title: nil,
    backgroundColor: KCAsset.Color.pastelGreen
  )
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(
      imageView,
      titleLabel,
      discountRatioLabel,
      regularPriceLabel,
      discountPriceLabel,
      reviewView,
      tagStack
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
    
    discountRatioLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.leading.equalTo(contentView)
    }
    
    regularPriceLabel.snp.makeConstraints { make in
      make.leading.equalTo(discountRatioLabel.snp.trailing).offset(5)
      make.centerY.equalTo(discountRatioLabel)
      make.trailing.lessThanOrEqualTo(contentView)
    }
    
    discountPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(discountRatioLabel.snp.bottom).offset(5)
      make.horizontalEdges.equalTo(contentView)
    }
    
    reviewView.snp.makeConstraints { make in
      make.top.equalTo(discountPriceLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(contentView)
    }
    
    tagStack.snp.makeConstraints { make in
      make.top.equalTo(reviewView.snp.bottom).offset(10)
      make.leading.equalTo(contentView)
    }
  }
  
  func setData(with post: CommercialPost) {
  
    imageView.kf.setImage(with: post.productImagesURL.first!)
    titleLabel.text = post.title
    discountRatioLabel.text = "\(post.price.discountRatio)%"
    regularPriceLabel.attributedText = post.price.regularPrice
      .formatted()
      .strikethroughAttributedString(strikethroughColor: KCAsset.Color.lightGrayForeground)
    discountPriceLabel.text = "\(post.price.discountPrice.formatted())원"
    reviewView.setData(reviews: post.reviews)
    
    updateTags(with: post)
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
