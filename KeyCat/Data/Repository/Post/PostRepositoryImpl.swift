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
    service: APIService,
    postMapper: PostMapper
  ) {
    self.service = service
    self.postMapper = postMapper
  }
  
  func uploadPostImages(files: [Data]) -> Single<[CommercialPost.URLString]> {
    return service.callPostImageUploadRequest(data: files)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .accessToken)
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
        let domainError = self.httpErrorToDomain(from: $0, domain: .createPost)
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
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchPosts)
        
        return .error(domainError)
      }
      .map { ($0.next_cursor, self.postMapper.toEntity($0.data)) }
  }
  
  func fetchSpecificPost(postID: CommercialPost.PostID) -> Single<CommercialPost?> {
    let router = PostRouter.specificPostFetch(id: postID)
    
    return service.callRequest(with: router, of: PostDTO.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .accessToken)
        
        return .error(domainError)
      }
      .map { self.postMapper.toEntity($0) }
  }
  
  func fetchCommercialPostsFromUser(
    userID: User.UserID,
    nextCursor: CommercialPost.PostID
  ) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    
    let query = FetchPostsQuery(
      next: nextCursor,
      limit: Constant.Network.fetchCountForOnce,
      postType: .keycat_commercialProduct
    )
    let router = PostRouter.postsFromUserFetch(userID: userID, query: query)
    
    return service.callRequest(with: router, of: FetchPostsResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchPosts)
        
        return .error(domainError)
      }
      .map { ($0.next_cursor, self.postMapper.toEntity($0.data)) }
  }
  
  func bookmark(postID: CommercialPost.PostID, isOn: Bool) -> Single<Bool> {
    let request = LikePostRequest(like_status: isOn)
    let router = LikeRouter.like(postID: postID, request: request)
    
    return service.callRequest(with: router, of: LikePostResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .likePost)
        
        return .error(domainError)
      }
      .map { $0.like_status }
  }
  
  func fetchBookmarkPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])> {
    
    let query = FetchLikePostsQuery(
      next: nextCursor,
      limit: Constant.Network.fetchCountForOnce
    )
    let router = LikeRouter.likePostsFetch(query: query)
    
    return service.callRequest(with: router, of: FetchPostsResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchPosts)
        
        return .error(domainError)
      }
      .map { ($0.next_cursor, self.postMapper.toEntity($0.data)) }
  }
  
  func addPostInCart(postID: CommercialPost.PostID) -> Single<Bool> {
    let request = LikePostRequest(like_status: true)
    let router = LikeRouter.like2(postID: postID, request: request)
    
    return service.callRequest(with: router, of: LikePostResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .likePost)
        
        return .error(domainError)
      }
      .map { $0.like_status }
  }
  
  func removePostFromCart(postID: CommercialPost.PostID) -> Single<Bool> {
    let request = LikePostRequest(like_status: false)
    let router = LikeRouter.like2(postID: postID, request: request)
    
    return service.callRequest(with: router, of: LikePostResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .likePost)
        
        return .error(domainError)
      }
      .map { $0.like_status }
  }
  
  func fetchCartPosts() -> Single<[CommercialPost]> {
    
    let query = FetchLikePostsQuery(next: "", limit: "10000")
    let router = LikeRouter.like2PostsFetch(query: query)
    
    return service.callRequest(with: router, of: FetchPostsResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchPosts)
        
        return .error(domainError)
      }
      .map { self.postMapper.toEntity($0.data) }
  }
  
  func fetchAllCommercialPosts() -> Single<[CommercialPost]> {
    
    let query = FetchPostsQuery(next: "", limit: "10000", postType: .keycat_commercialProduct)
    let router = PostRouter.postsFetch(query: query)
    
    return service.callRequest(with: router, of: FetchPostsResponse.self)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchPosts)
        
        return .error(domainError)
      }
      .map { self.postMapper.toEntity($0.data) }
  }
  
  func deleteCommercialPost(postID: CommercialPost.PostID) -> Single<Void> {
    
    let router = PostRouter.postDelete(id: postID)
    
    return service.callReqeust(with: router)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .fetchPosts)
        
        return .error(domainError)
      }
  }
}
