//
//  AuthenticateBusinessInfoUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 4/24/24.
//

import RxSwift

protocol AuthenticateBusinessInfoUsecase {
  
  func execute(businessNumber: String) -> Single<BusinessInfo>
}
