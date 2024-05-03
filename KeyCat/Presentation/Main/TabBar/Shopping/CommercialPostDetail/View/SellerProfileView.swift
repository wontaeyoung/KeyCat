//
//  SellerProfileView.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import SnapKit
import RxCocoa

final class SellerProfileView: RxBaseView {
  
  private let sellerSectionLabel = KCLabel(title: "판매자", font: .bold(size: 15), color: .darkGray)
  private lazy var profileImageView = TappableImageView(image: nil).configured {
    $0.clipsToBounds = true
    $0.layer.configure {
      $0.cornerRadius = profileImageSize / 2
      $0.borderWidth = 1
      $0.borderColor = KCAsset.Color.lightGrayForeground.color.cgColor
    }
  }
  private let nicknameLabel = KCLabel(font: .medium(size: 14))
  
  private let profileImageSize: CGFloat = 40
  
  let profileTapEvent = PublishRelay<User>()
  
  var seller: User? {
    didSet {
      setData(seller: seller)
    }
  }
  
  override init() {
    super.init()
    
    profileImageView.tap
      .compactMap { self.seller }
      .bind(to: profileTapEvent)
      .disposed(by: disposeBag)
  }
  
  override func setHierarchy() {
    addSubviews(
      sellerSectionLabel,
      profileImageView,
      nicknameLabel
    )
  }
  
  override func setConstraint() {
    sellerSectionLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.horizontalEdges.equalToSuperview()
    }
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalTo(sellerSectionLabel.snp.bottom).offset(20)
      make.leading.equalToSuperview()
      make.size.equalTo(profileImageSize)
      make.bottom.equalToSuperview()
    }
    
    nicknameLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
      make.centerY.equalTo(profileImageView)
      make.trailing.equalToSuperview()
    }
  }
  
  private func setData(seller: User?) {
    guard let seller else { return }
    
    profileImageView.load(with: seller.profileImageURL)
    nicknameLabel.text = seller.nickname
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}