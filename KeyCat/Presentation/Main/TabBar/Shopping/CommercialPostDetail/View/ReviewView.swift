//
//  ReviewView.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

import UIKit
import SnapKit

final class ReviewView: RxBaseView {
  
  private let starIcon = UIImageView(image: KCAsset.Symbol.reviewScore)
  private let scoreLabel = KCLabel(font: .medium(size: 13))
  private let countLabel = KCLabel(font: .medium(size: 13), color: .lightGrayForeground)
  
  var reviews: [CommercialReview] = [] {
    didSet {
      setData(reviews: reviews)
    }
  }
  
  override init() {
    super.init()
  }
  
  override func setHierarchy() {
    addSubviews(
      starIcon,
      scoreLabel,
      countLabel
    )
  }
  
  override func setConstraint() {
    starIcon.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.height.equalToSuperview()
      make.size.equalTo(15)
    }
    
    scoreLabel.snp.makeConstraints { make in
      make.leading.equalTo(starIcon.snp.trailing).offset(5)
      make.centerY.equalTo(starIcon)
    }
    
    countLabel.snp.makeConstraints { make in
      make.leading.equalTo(scoreLabel.snp.trailing).offset(2)
      make.trailing.lessThanOrEqualToSuperview()
      make.centerY.equalTo(starIcon)
    }
  }
  
  func setData(reviews: [CommercialReview]) {
    scoreLabel.text = reviews.isEmpty ? "-" : reviews.averageScore.rounded
    countLabel.text = "(\(reviews.count))"
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
