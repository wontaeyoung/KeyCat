//
//  CheckEmailDuplicationUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 4/20/24.
//

import RxSwift

protocol CheckEmailDuplicationUsecase {
  
  func execute(email: String) -> Single<Bool>
}
