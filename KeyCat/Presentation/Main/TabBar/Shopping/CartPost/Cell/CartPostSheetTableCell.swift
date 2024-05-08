//
//  CartPostSheetTableCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CartPostSheetTableCell: RxBaseTableViewCell {
  
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
  private let titleLabel = KCLabel(font: .medium(size: 14), line: 2)
  private let priceView = ProductPriceView()
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
    selectionStyle = .none
    
    contentView.addSubviews(containerView)
    
    containerView.addSubviews(
      productImageView,
      titleLabel,
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
      make.size.equalTo(80)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(productImageView.snp.trailing).offset(20)
      make.trailing.equalToSuperview()
    }
    
    priceView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(titleLabel)
      make.bottom.equalToSuperview()
    }
  }
  
  func setData(post: CommercialPost) {
    
    productImageView.load(with: post.mainImageURL)
    titleLabel.text = post.title
    priceView.productPrice = post.price
  }
}
