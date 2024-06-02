//
//  HandleCommercialPostUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/7/24.
//

import RxSwift

final class HandleCommercialPostUsecaseImpl: HandleCommercialPostUsecase {
  
  private let postRepository: any PostRepository
  
  init(postRepository: any PostRepository) {
    self.postRepository = postRepository
  }
  
  func deletePost(postID: CommercialPost.PostID) -> Single<Void> {
    return postRepository.deleteCommercialPost(postID: postID)
  }
}
