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
}
