//
//  HandleReviewUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

protocol HandleReviewUsecase {
  
  func deleteReview(postID: CommercialPost.PostID, reviewID: CommercialReview.ReviewID) -> Single<Void>
}
