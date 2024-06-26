//
//  FetchCommercialPostUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import Foundation
import RxSwift

protocol FetchCommercialPostUsecase {
  
  func fetchPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
  func fetchSepecificPost(postID: CommercialPost.PostID) -> Single<CommercialPost?>
  func fetchCommercialPostsFromUser(userID: User.UserID, nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
  func fetchBookmarkPosts(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
  func fetchCartPosts() -> Single<[CommercialPost]>
  func fetchFilteredPosts(filter: @escaping (CommercialPost) -> Bool) -> Single<[CommercialPost]>
}
