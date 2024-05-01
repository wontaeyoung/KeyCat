//
//  CreatePostUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

import Foundation
import RxSwift

final class CreatePostUsecaseImpl: CreatePostUsecase {
  
  private let postRepository: PostRepository
  
  init(postRepository: PostRepository = PostRepositoryImpl()) {
    self.postRepository = postRepository
  }
  
  func execute(files: [Data], post: CommercialPost) -> Single<Bool> {
    return postRepository.uploadPostImages(files: files)
      .flatMap { files in
        let post = post.applied { $0.files = files }
        
        return self.postRepository.createCommercialPost(
          post: post,
          isUpdateImages: files.isEmpty == false
        )
      }
      .map { $0 != nil }
  }
}
