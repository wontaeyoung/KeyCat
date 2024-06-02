//
//  PaymentUsecaseImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import RxSwift

final class PaymentUsecaseImpl: PaymentUsecase {
  
  private let paymentRepository: any PaymentRepository
  
  init(paymentRepository: any PaymentRepository) {
    self.paymentRepository = paymentRepository
  }
  
  func valid(post: CommercialPost, impUID: String) -> Single<Void> {
    
    return paymentRepository.validPayment(post: post, impUID: impUID)
  }
  
  func fetchPayments() -> Single<[CommercialPayment]> {
    return .just([])
  }
}
