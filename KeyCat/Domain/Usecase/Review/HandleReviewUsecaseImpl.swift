//
//  HandleReviewUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

final class HandleReviewUsecaseImpl: HandleReviewUsecase {
  
  private let reviewRepository: ReviewRepository
  
  init(reviewRepository: ReviewRepository = ReviewRepositoryImpl()) {
    self.reviewRepository = reviewRepository
  }
  
  func deleteReview(postID: CommercialPost.PostID, reviewID: CommercialReview.CommentID) -> Single<Void> {
    return reviewRepository.deleteCommercialReview(postID: postID, reviewID: reviewID)
  }
}
