//
//  BookmarkUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import Foundation
import RxSwift

protocol BookmarkUsecase {
  
  func execute(postID: CommercialPost.PostID, isOn: Bool) -> Single<CommercialPost?>
}
