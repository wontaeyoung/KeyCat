//
//  HandleCommercialPostUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/7/24.
//

import Foundation
import RxSwift

protocol HandleCommercialPostUsecase {
  
  func deletePost(postID: CommercialPost.PostID) -> Single<Void>
}
