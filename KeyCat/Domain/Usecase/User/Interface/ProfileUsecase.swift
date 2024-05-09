//
//  ProfileUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import Foundation
import RxSwift

protocol ProfileUsecase {
  
  func fetchMyProfile() -> Single<Profile>
  func fetchOtherProfile(userID: User.UserID) -> Single<Profile>
  func updateSellerAuthority() -> Single<Profile>
  func updateProfile(nick: String?, profile: Data?) -> Single<Profile>
}
