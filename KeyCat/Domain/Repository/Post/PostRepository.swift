//
//  PostRepository.swift
//  KeyCat
//
//  Created by 원태영 on 5/1/24.
//

import Foundation
import RxSwift

protocol PostRepository {
  
  func uploadPostImages(files: [Data]) -> Single<[CommercialPost.URLString]>
  func createCommercialPost(post: CommercialPost, isUpdateImages: Bool) -> Single<CommercialPost?>
  func fetchCommercialPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
  func fetchSpecificPost(postID: CommercialPost.PostID) -> Single<CommercialPost?>
  func fetchCommercialPostsFromUser(userID: User.UserID, nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
  func bookmark(postID: CommercialPost.PostID, isOn: Bool) -> Single<Bool>
  func fetchBookmarkPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
  func addCart(postID: CommercialPost.PostID, adding: Bool) -> Single<Bool>
  func fetchCartPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
}
