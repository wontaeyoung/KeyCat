//
//  ReviewRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import Foundation
import RxSwift

final class ReviewRepositoryImpl: ReviewRepository, HTTPErrorTransformer {
  
  private let service: APIService
  private let commentMapper: CommentMapper
  
  init(
    service: APIService,
    commentMapper: CommentMapper
  ) {
    self.service = service
    self.commentMapper = commentMapper
  }
  
  func createCommercialReview(postID: CommercialPost.PostID, review: CommercialReview) -> Single<CommercialReview?> {
    
    guard let request = commentMapper.toRequest(review) else {
      return .error(KCError.missingRequired)
    }
    
    let router = CommentRouter.commentCreate(postID: postID, request: request)
    
    return service.callRequest(with: router, of: CommentDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .createReview)
        return .error(domainError)
      }
      .map { self.commentMapper.toEntity($0) }
  }
  
  func deleteCommercialReview(postID: CommercialPost.PostID, reviewID: CommercialReview.ReviewID) -> Single<Void> {
    
    let router = CommentRouter.commentDelete(postID: postID, commentID: reviewID)
    
    return service.callReqeust(with: router)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .deleteReview)
        return .error(domainError)
      }
  }
}
