//
//  PaymentUsecase.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import RxSwift

protocol PaymentUsecase {
  
  func valid(post: CommercialPost, impUID: String) -> Single<Void>
  func fetchPayments() -> Single<[CommercialPayment]>
}
