//
//  CreateReviewUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

final class CreateReviewUsecaseImpl: CreateReviewUsecase {
  
  private let reviewRepository: any ReviewRepository
  
  init(reviewRepository: any ReviewRepository) {
    self.reviewRepository = reviewRepository
  }
  
  func execute(postID: CommercialPost.PostID, review: CommercialReview) -> Single<CommercialReview?> {
    return reviewRepository.createCommercialReview(postID: postID, review: review)
  }
}
