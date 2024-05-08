//
//  CartPostTableCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CartPostTableCell: RxBaseTableViewCell {
  
  // MARK: - UI
  private let containerView = UIView()
  private let checkboxButton = CheckboxButton()
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
  private let deliveryInfoLabel = KCLabel(font: .medium(size: 13), color: .lightGrayForeground)
  private let priceView = ProductPriceView()
  private let deleteButton = KCButton(style: .icon, image: KCAsset.Symbol.leaveButton)
  
  // MARK: - Property
  var checkAction: (() -> Void)?
  var deleteAction: (() -> Void)?
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    
    selectionStyle = .none
    
    contentView.addSubviews(
      checkboxButton,
      containerView,
      deleteButton
    )
    
    containerView.addSubviews(
      productImageView,
      titleLabel,
      deliveryInfoLabel,
      priceView
    )
  }
  
  override func setConstraint() {
    
    checkboxButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
      make.size.equalTo(25)
    }
    
    containerView.snp.makeConstraints { make in
      make.leading.equalTo(checkboxButton.snp.trailing).offset(10)
      make.verticalEdges.equalToSuperview().inset(20)
      make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
    }
    
    deleteButton.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(10)
      make.trailing.equalToSuperview().inset(10)
      make.size.equalTo(35)
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
    }
    
    deliveryInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(priceView.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(titleLabel)
      make.bottom.equalToSuperview()
    }
  }
  
  override func bind() {
    
    checkboxButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.checkAction?()
      }
      .disposed(by: disposeBag)
    
    deleteButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.deleteAction?()
      }
      .disposed(by: disposeBag)
  }
  
  func setData(post: CommercialPost, checkStateList: [CommercialPost.PostID]) {
    
    productImageView.load(with: post.mainImageURL)
    titleLabel.text = post.title
    priceView.productPrice = post.price
    deliveryInfoLabel.text = "\(post.delivery.price.name) | \(post.delivery.schedule.name)배송"
    
    checkboxButton.isOn.accept(checkStateList.contains(post.postID))
  }
}
