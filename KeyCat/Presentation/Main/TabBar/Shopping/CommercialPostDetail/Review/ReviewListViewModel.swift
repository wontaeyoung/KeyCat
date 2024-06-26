//
//  ReviewListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import RxSwift
import RxCocoa

final class ReviewListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let backTapEvent: PublishRelay<Void>
    let createReviewTapEvent: PublishRelay<Void>
    let reviewCellTapEvent: PublishRelay<CommercialReview>
    
    init(
      backTapEvent: PublishRelay<Void> = .init(),
      createReviewTapEvent: PublishRelay<Void> = .init(),
      reviewCellTapEvent: PublishRelay<CommercialReview> = .init()
    ) {
      self.backTapEvent = backTapEvent
      self.createReviewTapEvent = createReviewTapEvent
      self.reviewCellTapEvent = reviewCellTapEvent
    }
  }
  
  struct Output {
    let reviews: Driver<[CommercialReview]>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  private let post: BehaviorRelay<CommercialPost>
  
  // MARK: - Initializer
  init(post: BehaviorRelay<CommercialPost>) {
    self.post = post
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let reviews = BehaviorRelay<[CommercialReview]>(value: post.value.reviews)
    
    /// 리뷰가 추가되면 원본 포스트에 반영
    reviews
      .bind(with: self) { owner, reviews in
        owner.updateReviewInPost(updatedReviews: reviews)
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 코디네이터 해제를 위해 커스텀 Back 버튼 동작
    input.backTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
        owner.coordinator?.end()
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 작성 이벤트 > 리뷰 작성 화면 연결
    input.createReviewTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showCreateCommercialReviewView(post: owner.post.value, reviews: reviews)
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 셀 탭 이벤트 > 리뷰 상세 화면 연결
    input.reviewCellTapEvent
      .bind(with: self) { owner, review in
        owner.coordinator?.showCommercialReviewDetailView(postID: owner.post.value.postID, review: review, reviews: reviews)
      }
      .disposed(by: disposeBag)
    
    return Output(
      reviews: reviews.asDriver()
    )
  }
  
  private func updateReviewInPost(updatedReviews: [CommercialReview]) {
    let currentPost = post.value.applied { $0.reviews = updatedReviews }
    post.accept(currentPost)
  }
}
