//
//  FetchProfileUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift

protocol FetchProfileUsecase {
  
  func fetchMyProfile() -> Single<Profile>
}
