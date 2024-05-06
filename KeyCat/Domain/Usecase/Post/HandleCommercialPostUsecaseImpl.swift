//
//  HandleCommercialPostUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/7/24.
//

import RxSwift

final class HandleCommercialPostUsecaseImpl: HandleCommercialPostUsecase {
  
  private let postRepository: PostRepository
  
  init(postRepository: PostRepository = PostRepositoryImpl()) {
    self.postRepository = postRepository
  }
  
  func deletePost(postID: CommercialPost.PostID) -> Single<Void> {
    return postRepository.deleteCommercialPost(postID: postID)
  }
}
