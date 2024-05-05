//
//  MyProfileTableCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyProfileTableCell: RxBaseTableViewCell {
  
  // MARK: - UI
  private let containerView = UIView()
  private let titleLabel = KCLabel(font: .bold(size: 16))
  private let countLabel = KCLabel(font: .medium(size: 16), alignment: .right)
  
  // MARK: - Property
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(containerView)
    
    containerView.addSubviews(
      titleLabel,
      countLabel
    )
  }
  
  override func setConstraint() {
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
      make.height.equalTo(titleLabel)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.trailing.lessThanOrEqualTo(countLabel.snp.leading)
    }
    
    countLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }
  
  func setData(rowType: ProfileViewController.ProfileRow, profile: Profile) {
    titleLabel.text = rowType.title
    countLabel.text = .defaultValue
    
    switch rowType {
      case .writingPosts:
        titleLabel.textColor = KCAsset.Color.black.color
        countLabel.text = UserInfoService.hasSellerAuthority ? profile.postIDs.count.description : "-"
        
      case .following:
        countLabel.text = profile.following.count.description
      case .follower:
        countLabel.text = profile.followers.count.description
      case .withdraw:
        titleLabel.textColor = KCAsset.Color.incorrect
      case .bookmark, .updateProfile:
        break
    }
  }
}
