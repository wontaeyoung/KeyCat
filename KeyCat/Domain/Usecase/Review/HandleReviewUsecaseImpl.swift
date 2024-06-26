//
//  HandleReviewUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

final class HandleReviewUsecaseImpl: HandleReviewUsecase {
  
  private let reviewRepository: any ReviewRepository
  
  init(reviewRepository: any ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func deleteReview(postID: CommercialPost.PostID, reviewID: CommercialReview.ReviewID) -> Single<Void> {
    return reviewRepository.deleteCommercialReview(postID: postID, reviewID: reviewID)
  }
}
