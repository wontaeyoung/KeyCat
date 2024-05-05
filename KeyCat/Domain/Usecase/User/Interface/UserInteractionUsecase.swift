//
//  UserInteractionUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

protocol UserInteractionUsecase {
  
  func follow(userID: User.UserID) -> Single<Bool>
  func unfollow(userID: User.UserID) -> Single<Bool>
}
