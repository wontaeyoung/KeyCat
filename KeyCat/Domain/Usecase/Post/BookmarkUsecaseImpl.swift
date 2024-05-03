//
//  BookmarkUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import Foundation
import RxSwift

final class BookmarkUsecaseImpl: BookmarkUsecase {
  
  private let postRepository: PostRepository
  
  init(postRepository: PostRepository = PostRepositoryImpl()) {
    self.postRepository = postRepository
  }
  
  func execute(postID: CommercialPost.PostID, isOn: Bool) -> Single<CommercialPost?> {
    return postRepository.bookmark(postID: postID, isOn: isOn)
      .flatMap { _ in
        return self.postRepository.fetchSpecificPost(postID: postID)
      }
  }
}
