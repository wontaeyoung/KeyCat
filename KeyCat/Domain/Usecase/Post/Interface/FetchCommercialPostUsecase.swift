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
}
