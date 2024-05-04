//
//  CommercialReviewDetailViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class CommercialReviewDetailViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let profileTapEvent: PublishRelay<Void>
    
    init(
      profileTapEvent: PublishRelay<Void> = .init()
    ) {
      self.profileTapEvent = profileTapEvent
    }
  }
  
  struct Output {
    let review: Driver<CommercialReview>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  
  private let postID: CommercialPost.PostID
  private let review: BehaviorRelay<CommercialReview>
  private let reviews: BehaviorRelay<[CommercialReview]>
  
  // MARK: - Initializer
  init(
    postID: CommercialPost.PostID,
    review: CommercialReview,
    reviews: BehaviorRelay<[CommercialReview]>
  ) {
    self.postID = postID
    self.review = BehaviorRelay(value: review)
    self.reviews = reviews
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output(
      review: review.asDriver()
    )
  }
}
