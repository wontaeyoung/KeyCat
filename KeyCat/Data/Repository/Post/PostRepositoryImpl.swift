//
//  PostRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

import Foundation
import RxSwift

final class PostRepositoryImpl: PostRepository, HTTPErrorTransformer {
  
  private let service: APIService
  private let postMapper: PostMapper
  
  init(
    service: APIService = APIService(),
    postMapper: PostMapper = PostMapper()
  ) {
    self.service = service
    self.postMapper = postMapper
  }
  
  func uploadPostImages(files: [Data]) -> Single<[CommercialPost.URLString]> {
    return service.callImageUploadRequest(data: files)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .accessToken)
        return .error(domainError)
      }
      .map { $0.files }
  }
  
  func createCommercialPost(post: CommercialPost, isUpdateImages: Bool) -> Single<CommercialPost?> {
    guard let request = postMapper.toRequest(post, isUpdateImages: isUpdateImages) else {
      return .error(KCError.missingRequired)
    }
    
    let router = PostRouter.postCreate(request: request)
    
    return service.callRequest(with: router, of: PostDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .createPost)
        return .error(domainError)
      }
      .map { self.postMapper.toEntity($0) }
  }
}
