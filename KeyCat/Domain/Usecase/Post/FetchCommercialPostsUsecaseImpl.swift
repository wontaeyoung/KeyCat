//
//  FetchCommercialPostsUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import Foundation
import RxSwift

final class FetchCommercialPostsUsecaseImpl: FetchCommercialPostsUsecase {
  
  private let postRepository: PostRepository
  
  init(postRepository: PostRepository = PostRepositoryImpl()) {
    self.postRepository = postRepository
  }
  
  func execute(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    return postRepository.fetchCommercialPosts(nextCursor: nextCursor)
  }
}
