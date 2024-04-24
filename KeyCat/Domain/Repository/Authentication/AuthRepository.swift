//
//  AuthRepository.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

import RxSwift

protocol AuthRepository {
  
  func checkEmailDuplication(email: String) -> Single<Bool>
  func authenticateBusinessInfo(businessNumber: String) -> Single<BusinessInfo>
}
