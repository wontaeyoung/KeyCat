//
//  ReviewRepository.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

protocol ReviewRepository {
  
  func createCommercialReview(postID: CommercialPost.PostID, review: CommercialReview) -> Single<CommercialReview?>
  func deleteCommercialReview(postID: CommercialPost.PostID, reviewID: CommercialReview.ReviewID) -> Single<Void>
}
