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
  
  func fetchCommercialPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    let query = FetchPostsQuery(
      next: nextCursor,
      limit: Constant.Network.fetchCountForOnce,
      postType: .keycat_commercialProduct
    )
    let router = PostRouter.postsFetch(query: query)
    
    return service.callRequest(with: router, of: FetchPostsResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .fetchPosts)
        
        return .error(domainError)
      }
      .map { ($0.next_cursor, self.postMapper.toEntity($0.data)) }
  }
  
  func fetchSpecificPost(postID: CommercialPost.PostID) -> Single<CommercialPost?> {
    let router = PostRouter.specificPostFetch(id: postID)
    
    return service.callRequest(with: router, of: PostDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .accessToken)
        
        return .error(domainError)
      }
      .map { self.postMapper.toEntity($0) }
  }
  
  func bookmark(postID: CommercialPost.PostID, isOn: Bool) -> Single<Bool> {
    let request = LikePostRequest(like_status: isOn)
    let router = LikeRouter.like(postID: postID, request: request)
    
    return service.callRequest(with: router, of: LikePostResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .likePost)
        
        return .error(domainError)
      }
      .map { $0.like_status }
  }
  
  func addCart(postID: CommercialPost.PostID, adding: Bool) -> Single<Bool> {
    let request = LikePostRequest(like_status: adding)
    let router = LikeRouter.like2(postID: postID, request: request)
    
    return service.callRequest(with: router, of: LikePostResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, style: .likePost)
        
        return .error(domainError)
      }
      .map { $0.like_status }
  }
}
