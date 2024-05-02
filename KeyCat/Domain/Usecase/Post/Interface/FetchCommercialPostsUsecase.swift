//
//  FetchCommercialPostsUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import Foundation
import RxSwift

protocol FetchCommercialPostsUsecase {
  
  func execute(nextCursor: CommercialPost.PostID) -> Single<(CommercialPost.PostID, [CommercialPost])>
}
