//
//  CommercialPostInteractionUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import Foundation
import RxSwift

final class CommercialPostInteractionUsecaseImpl: CommercialPostInteractionUsecase {
  
  private let postRepository: PostRepository
  
  init(postRepository: PostRepository = PostRepositoryImpl()) {
    self.postRepository = postRepository
  }
  
  func bookmark(postID: CommercialPost.PostID, isOn: Bool) -> Single<CommercialPost?> {
    return postRepository.bookmark(postID: postID, isOn: isOn)
      .flatMap { _ in
        return self.postRepository.fetchSpecificPost(postID: postID)
      }
  }
}
