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
  private let nicknameLabel = KCLabel(font: .bold(size: 20))
  private let sellerIcon = UIImageView().configured {
    $0.contentMode = .scaleAspectFit
  }
  private let followingLabel = KCLabel(font: .medium(size: 16))
  private let followVerticalDivider = KCLabel(
    title: "|",
    font: .bold(size: 16),
    color: .lightGrayForeground,
    alignment: .center
  )
  private let followerLabel = KCLabel(font: .medium(size: 16))
  
  var profile: Profile? {
    didSet {
      setData(profile: profile)
    }
  }
  
  var followerCount: Int? {
    didSet {
      setFollowerLabel(followerCount: followerCount)
    }
  }
  
  private let profileImageSize: CGFloat = 80
  
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
      make.bottom.equalToSuperview()
    }
    
    nicknameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalTo(profileImageView.snp.trailing).offset(20)
    }
    
    sellerIcon.snp.makeConstraints { make in
      make.centerY.equalTo(nicknameLabel)
      make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
      make.trailing.lessThanOrEqualToSuperview()
      make.size.equalTo(30)
    }
    
    followingLabel.snp.makeConstraints { make in
      make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
      make.leading.equalTo(nicknameLabel)
    }
    
    followVerticalDivider.snp.makeConstraints { make in
      make.top.equalTo(followingLabel)
      make.leading.equalTo(followingLabel.snp.trailing).offset(10)
    }
    
    followerLabel.snp.makeConstraints { make in
      make.top.equalTo(followingLabel)
      make.leading.equalTo(followVerticalDivider.snp.trailing).offset(10)
      make.trailing.lessThanOrEqualToSuperview()
    }
  }
  
  func setData(profile: Profile?) {
    guard let profile else { return }
    
    profileImageView.load(with: profile.profileImageURL)
    nicknameLabel.text = profile.nickname
    followingLabel.text = "팔로잉 \(profile.following.count)"
    
    if UserInfoService.hasSellerAuthority { sellerIcon.image = KCAsset.Symbol.seller }
  }
  
  func setFollowerLabel(followerCount: Int?) {
    guard let followerCount else { return }
    
    followerLabel.text = "팔로워 \(followerCount)"
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
