//
//  PaymentUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import RxSwift

final class PaymentUsecaseImpl: PaymentUsecase {
  
  private let paymentRepository: PaymentRepository
  
  init(paymentRepository: PaymentRepository = PaymentRepositoryImpl()) {
    self.paymentRepository = paymentRepository
  }
  
  func valid(post: CommercialPost, impUID: String) -> Single<Void> {
    
    return paymentRepository.validPayment(post: post, impUID: impUID)
  }
  
  func fetchPayments() -> Single<[CommercialPayment]> {
    return .just([])
  }
}
