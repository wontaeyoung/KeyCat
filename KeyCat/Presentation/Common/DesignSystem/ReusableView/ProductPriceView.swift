//
//  ProductPriceView.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import UIKit
import SnapKit

final class ProductPriceView: RxBaseView {
  
  private let discountRatioLabel = KCLabel(style: .productCellPrice)
  private let regularPriceLabel = KCLabel(style: .productCellPrice)
  private let discountPriceLabel = KCLabel(style: .productCellTitle)
  
  override init() {
    super.init()
  }
  
  override func setHierarchy() {
    addSubviews(
      discountRatioLabel,
      regularPriceLabel,
      discountPriceLabel
    )
  }
  
  override func setConstraint() {
    discountRatioLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
    }
    
    regularPriceLabel.snp.makeConstraints { make in
      make.leading.equalTo(discountRatioLabel.snp.trailing).offset(5)
      make.centerY.equalTo(discountRatioLabel)
      make.trailing.lessThanOrEqualToSuperview()
    }
    
    discountPriceLabel.snp.makeConstraints { make in
      make.top.equalTo(discountRatioLabel.snp.bottom).offset(5)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }
  
  func setData(price: CommercialPrice) {
    discountRatioLabel.text = "\(price.discountRatio)%"
    regularPriceLabel.attributedText = price.regularPrice
      .formatted()
      .strikethroughAttributedString(strikethroughColor: KCAsset.Color.lightGrayForeground)
    discountPriceLabel.text = "\(price.discountPrice.formatted())원"
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
