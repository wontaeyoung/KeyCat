//
//  ChatRoomTableCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatRoomTableCell: RxBaseTableViewCell {
  
  // MARK: - UI
  private let containerView = UIView()
  private lazy var profileImageView = ProfileImageView(size: profileImageSize)
  private let nicknameLabel = KCLabel(font: .bold(size: 16))
  private let contentLabel = KCLabel(font: .medium(size: 14), color: .lightGrayForeground)
  private let timestampLabel = KCLabel(font: .medium(size: 13), color: .lightGrayForeground, alignment: .right)
  private let newCountLabel = TagLabel(title: nil, horizontalInset: 4, backgroundColor: .brand)
  
  // MARK: - Property
  private let profileImageSize: CGFloat = 40
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    contentView.addSubviews(containerView)
    containerView.addSubviews(
      profileImageView,
      nicknameLabel,
      contentLabel,
      timestampLabel,
      newCountLabel
    )
  }
  
  override func setConstraint() {
    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(20)
    }
    
    profileImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.verticalEdges.equalToSuperview()
      make.size.equalTo(profileImageSize)
    }
    
    nicknameLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView).offset(10)
      make.bottom.equalTo(profileImageView.snp.centerY).offset(-5)
      make.trailing.lessThanOrEqualTo(timestampLabel.snp.leading).offset(-10)
    }
    
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
      make.horizontalEdges.equalTo(nicknameLabel)
    }
    
    timestampLabel.snp.makeConstraints { make in
      make.centerY.equalTo(nicknameLabel)
      make.trailing.equalToSuperview()
    }
    
    newCountLabel.snp.makeConstraints { make in
      make.centerY.equalTo(contentLabel)
      make.trailing.equalToSuperview()
    }
  }
  
  func setData(chatRoom: ChatRoom) {
    profileImageView.load(with: chatRoom.otherUser.profileImageURL)
    nicknameLabel.text = chatRoom.otherUser.nickname
    contentLabel.text = chatRoom.lastChat?.content
    timestampLabel.text = DateManager.shared.timestamp(when: chatRoom.updatedAt)
  }
}
