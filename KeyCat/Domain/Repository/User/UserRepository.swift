//
//  UserRepository.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

protocol UserRepository {
  
  func fetchSellerAuthority() -> Single<Bool>
  func fetchMyProfile() -> Single<Profile>
  func fetchOtherProfile(userID: User.UserID) -> Single<Profile>
  func updateProfileImage(with profileData: Data?) -> Single<Profile>
}
