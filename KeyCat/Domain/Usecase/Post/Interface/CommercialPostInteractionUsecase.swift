//
//  CommercialPostInteractionUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import Foundation
import RxSwift

protocol CommercialPostInteractionUsecase {
  
  func bookmark(postID: CommercialPost.PostID, isOn: Bool) -> Single<CommercialPost?>
  func addCart(postID: CommercialPost.PostID, adding: Bool) -> Single<CommercialPost?>
}
