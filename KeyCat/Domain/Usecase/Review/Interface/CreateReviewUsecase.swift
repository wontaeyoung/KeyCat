//
//  CreateReviewUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

protocol CreateReviewUsecase {
  
  func execute(postID: CommercialPost.PostID, review: CommercialReview) -> Single<CommercialReview?>
}
