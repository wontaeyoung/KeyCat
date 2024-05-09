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
  func updateSellerAuthority() -> Single<Profile>
  func updateProfile(nick: String?, profile: Data?) -> Single<Profile>
  func follow(userID: User.UserID) -> Single<Bool>
  func unfollow(userID: User.UserID) -> Single<Bool>
}
