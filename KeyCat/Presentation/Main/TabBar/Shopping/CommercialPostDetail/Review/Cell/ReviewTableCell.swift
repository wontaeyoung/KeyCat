//
//  ReviewTableCell.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ReviewTableCell: RxBaseTableViewCell {
  
  // MARK: - UI
  private let containerView = UIView()
  private lazy var profileImageView = ProfileImageView(size: profileImageSize)
  private let nicknameLabel = KCLabel(font: .medium(size: 13))
  private let dateLabel = KCLabel(font: .medium(size: 13), color: .darkGray, alignment: .right)
  private lazy var reviewStarStack = UIStackView().configured {
    $0.axis = .horizontal
    $0.spacing = 2
  }
  private let contentLabel = KCLabel(font: .medium(size: 13), line: 5, isUpdatingLineSpacing: true)
  
  // MARK: - Property
  private let profileImageSize: CGFloat = 40
  let profileTapEvent = PublishRelay<User>()
  
  // MARK: - Life Cycle
  override func prepareForReuse() {
    super.prepareForReuse()
    
    reviewStarStack.removeAllArrangedSubviews()
  }
  
  override func setHierarchy() {
    contentView.addSubviews(containerView)
    
    containerView.addSubviews(
      profileImageView,
      nicknameLabel,
      dateLabel,
      reviewStarStack,
      contentLabel
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
    }
    
    nicknameLabel.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
      make.centerY.equalTo(profileImageView)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.leading.equalTo(nicknameLabel.snp.trailing).offset(10)
      make.centerY.equalTo(profileImageView)
      make.trailing.equalToSuperview()
    }
    
    reviewStarStack.snp.makeConstraints { make in
      make.top.equalTo(profileImageView.snp.bottom).offset(5)
      make.leading.equalToSuperview()
    }
    
    contentLabel.snp.makeConstraints { make in
      make.top.equalTo(reviewStarStack.snp.bottom).offset(20)
      make.horizontalEdges.equalToSuperview()
      make.bottom.lessThanOrEqualToSuperview()
    }
  }
  
  func setData(review: CommercialReview) {
    profileImageView.load(with: review.creator.profileImageURL)
    nicknameLabel.text = review.creator.nickname
    dateLabel.text = review.dateString
    contentLabel.text = review.content
    
    stackingReviewStar(rating: review.rating)
    
    profileImageView.tap
      .compactMap { review.creator }
      .bind(to: profileTapEvent)
      .disposed(by: disposeBag)
  }
  
  private func stackingReviewStar(rating: CommercialReview.Rating) {
    (1...5).forEach { num in
      let imageView = UIImageView().configured {
        $0.contentMode = .scaleAspectFit
        $0.image = rating.rawValue >= num ? KCAsset.Symbol.reviewScore : KCAsset.Symbol.emptyReviewScore
        $0.snp.makeConstraints { make in make.size.equalTo(20) }
      }
      
      reviewStarStack.addArrangedSubview(imageView)
    }
  }
}
