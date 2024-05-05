//
//  ProductTableCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProductTableCell: RxBaseTableViewCell {
  
  // MARK: - UI
  private let containerView = UIView()
  private let productImageView = UIImageView().configured {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.configure {
      $0.cornerRadius = 10
      $0.borderColor = KCAsset.Color.lightGrayBackground.color.cgColor
      $0.borderWidth = 1
    }
  }
  private let titleLabel = KCLabel(font: .medium(size: 16), line: 2)
  private let reviewView = ReviewView()
  private let priceView = ProductPriceView()
  
  // MARK: - Property
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(containerView)
    
    containerView.addSubviews(
      productImageView,
      titleLabel,
      reviewView,
      priceView
    )
  }
  
  override func setConstraint() {
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }
    
    productImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.size.equalTo(100)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(productImageView.snp.trailing).offset(20)
      make.trailing.equalToSuperview()
    }
    
    reviewView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(titleLabel)
    }
    
    priceView.snp.makeConstraints { make in
      make.top.equalTo(reviewView.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(titleLabel)
      make.bottom.equalToSuperview()
    }
  }
  
  func setData(post: CommercialPost) {
    productImageView.load(with: post.mainImageURL)
    titleLabel.text = post.title
    reviewView.reviews = post.reviews
    priceView.productPrice = post.price
  }
}
