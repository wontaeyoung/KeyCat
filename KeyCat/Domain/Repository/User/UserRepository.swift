//
//  UserRepository.swift
//  KeyCat
//
//  Created by 원태영 on 4/25/24.
//

import Foundation
import RxSwift

protocol UserRepository {
  
  func updateProfileImage(with profileData: Data?) -> Single<Profile>
}
