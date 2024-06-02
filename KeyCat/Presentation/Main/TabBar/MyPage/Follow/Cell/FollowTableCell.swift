//
//  FollowTableCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowTableCell: RxBaseTableViewCell {
  
  // MARK: - UI
  private let containerView = UIView()
  private lazy var profileImageView = ProfileImageView(size: profileImageSize)
  private let nicknameLabel = KCLabel(font: .medium(size: 15))
  
  // MARK: - Property
  private let profileImageSize: CGFloat = 50
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(containerView)
    
    containerView.addSubviews(
      profileImageView,
      nicknameLabel
    )
  }
  
  override func setConstraint() {
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }
    
    profileImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
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
  
  func setData(follow: User) {
    profileImageView.load(with: follow.profileImageURL)
    nicknameLabel.text = follow.nickname
  }
}
