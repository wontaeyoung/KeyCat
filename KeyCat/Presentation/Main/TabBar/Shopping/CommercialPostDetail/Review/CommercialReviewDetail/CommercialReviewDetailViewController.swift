//
//  CommercialReviewDetailViewController.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommercialReviewDetailViewController: RxBaseViewController, ViewModelController {
  
  // MARK: - UI
  private lazy var menuBarItem = UIBarButtonItem(image: KCAsset.Symbol.menuBarItem).configured {
    let actions = HandleContentAction.allCases
      .map { action in
        return UIAction(
          title: action.title,
          image: action.image,
          attributes: action == .delete ? .destructive : []
        ) { _ in
          self.handleReviewAction.accept(action)
        }
      }
    
    $0.menu = UIMenu(title: "리뷰 변경", children: actions)
  }
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let containerView = UIView()
  
  private lazy var profileImageView = ProfileImageView(size: profileImageSize)
  private let nicknameLabel = KCLabel(font: .medium(size: 13))
  private let dateLabel = KCLabel(font: .medium(size: 13), color: .darkGray, alignment: .right)
  private lazy var reviewStarStack = UIStackView().configured {
    $0.axis = .horizontal
    $0.spacing = 2
  }
  private let contentLabel = KCLabel(font: .medium(size: 13), line: 0, isUpdatingLineSpacing: true)
  
  // MARK: - Property
  let viewModel: CommercialReviewDetailViewModel
  
  private let profileImageSize: CGFloat = 40
  private let handleReviewAction = PublishRelay<HandleContentAction>()
  
  // MARK: - Initializer
  init(viewModel: CommercialReviewDetailViewModel) {
    self.viewModel = viewModel
    
    super.init()
  }
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(scrollView)
    scrollView.addSubviews(contentView)
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
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints { make in
      make.width.equalTo(scrollView)
      make.verticalEdges.equalTo(scrollView)
    }
    
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
  
  override func bind() {
    
    let input = CommercialReviewDetailViewModel.Input()
    let output = viewModel.transform(input: input)
    
    /// 리뷰 데이터 표시
    output.review
      .drive(with: self) { owner, review in
        owner.setData(review: review)
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 삭제 토스트 완료 이벤트 전달
    output.reviewDeletedToast
      .drive(with: self) { owner, _ in
        owner.toast("리뷰가 삭제되었어요") { input.toastCompleteEvent.accept(()) }
      }
      .disposed(by: disposeBag)
    
    /// 프로필 이미지 탭 이벤트 전달
    profileImageView.tap
      .buttonThrottle()
      .bind(to: input.profileTapEvent)
      .disposed(by: disposeBag)
    
    /// 리뷰 변경 메뉴 아이템 탭 이벤트 전달
    handleReviewAction
      .bind(to: input.handleReviewAction)
      .disposed(by: disposeBag)
  }
  
  private func setData(review: CommercialReview) {
    profileImageView.load(with: review.creator.profileImageURL)
    nicknameLabel.text = review.creator.nickname
    dateLabel.text = review.dateString
    contentLabel.text = review.content
    
    stackingReviewStar(rating: review.rating)
    
    if review.isCreatedByMe {
      navigationItem.setRightBarButton(menuBarItem, animated: true)
    }
  }
  
  private func stackingReviewStar(rating: CommercialReview.Rating) {
    (1...5).forEach { num in
      let imageView = UIImageView().configured {
        $0.contentMode = .scaleAspectFit
        $0.image = rating.rawValue >= num ? KCAsset.Symbol.reviewScore : KCAsset.Symbol.emptyReviewScore
        $0.snp.makeConstraints { make in make.size.equalTo(30) }
      }
      
      reviewStarStack.addArrangedSubview(imageView)
    }
  }
}
