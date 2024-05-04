//
//  ProfileView.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit

final class ProfileView: RxBaseView {
  
  private lazy var profileImageView = TappableImageView(image: nil).configured {
    $0.clipsToBounds = true
    $0.layer.configure {
      $0.cornerRadius = profileImageSize / 2
      $0.borderWidth = 1
      $0.borderColor = KCAsset.Color.lightGrayForeground.color.cgColor
    }
  }
  private let nicknameLabel = KCLabel(font: .bold(size: 14))
  private let followingLabel = KCLabel(font: .medium(size: 13))
  private let followVerticalDivider = KCLabel(
    title: "|",
    font: .bold(size: 13),
    color: .lightGrayForeground,
    alignment: .center
  )
  private let followerLabel = KCLabel(font: .medium(size: 13))
  private let sellerIcon = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  
  var profile: Profile? {
    didSet {
      setData(profile: profile)
    }
  }
  
  private let profileImageSize: CGFloat = 50
  
  override init() {
    super.init()
  }
  
  override func setHierarchy() {
    addSubviews(
      profileImageView,
      nicknameLabel,
      followingLabel,
      followVerticalDivider,
      followerLabel,
      sellerIcon
    )
  }
  
  override func setConstraint() {
    profileImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.size.equalTo(profileImageSize)
    }
    
    nicknameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
      make.trailing.equalToSuperview()
    }
    
    followingLabel.snp.makeConstraints { make in
      make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
      make.leading.equalTo(nicknameLabel)
    }
    
    followVerticalDivider.snp.makeConstraints { make in
      make.top.equalTo(followingLabel)
      make.leading.equalTo(followingLabel.snp.trailing).offset(10)
    }
    
    followerLabel.snp.makeConstraints { make in
      make.top.equalTo(followingLabel)
      make.leading.equalTo(followVerticalDivider.snp.trailing).offset(10)
      make.trailing.equalToSuperview()
    }
    
    sellerIcon.snp.makeConstraints { make in
      make.top.equalTo(followingLabel.snp.bottom).offset(10)
      make.leading.equalTo(followingLabel)
      make.bottom.equalToSuperview()
      make.size.equalTo(20)
    }
  }
  
  func setData(profile: Profile?) {
    guard let profile else { return }
    
    profileImageView.load(with: profile.profileImageURL)
    nicknameLabel.text = profile.nickname
    followingLabel.text = "팔로잉 \(profile.folllowing.count)"
    followerLabel.text = "팔로워 \(profile.followers.count)"
    
    if UserInfoService.hasSellerAuthority { sellerIcon.image = KCAsset.Symbol.seller }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
