//
//  FetchCommercialPostUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import Foundation
import RxSwift

final class FetchCommercialPostUsecaseImpl: FetchCommercialPostUsecase {
  
  private let postRepository: PostRepository
  
  init(postRepository: PostRepository = PostRepositoryImpl()) {
    self.postRepository = postRepository
  }
  
  func fetchPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    return postRepository.fetchCommercialPosts(nextCursor: nextCursor)
  }
  
  func fetchSepecificPost(postID: CommercialPost.PostID) -> Single<CommercialPost?> {
    return postRepository.fetchSpecificPost(postID: postID)
  }
  
  func fetchCommercialPostsFromUser(userID: User.UserID, nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    return postRepository.fetchCommercialPostsFromUser(userID: userID, nextCursor: nextCursor)
  }
  
  func fetchBookmarkPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    return postRepository.fetchBookmarkPosts(nextCursor: nextCursor)
  }
  
  func fetchCartPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    return postRepository.fetchCartPosts(nextCursor: nextCursor)
  }
}
