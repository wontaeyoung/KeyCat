//
//  PaymentRepositoryImpl.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import Foundation
import RxSwift

final class PaymentRepositoryImpl: PaymentRepository, HTTPErrorTransformer {
  
  private let service: APIService
  private let paymentMapper: PaymentMapper
  
  init(
    service: APIService = APIService(),
    paymentMapper: PaymentMapper = PaymentMapper()
  ) {
    self.service = service
    self.paymentMapper = paymentMapper
  }
  
  func validPayment(post: CommercialPost, impUID: String) -> Single<Void> {
    
    let request = PaymentValidationRequest(
      imp_uid: impUID, 
      post_id: post.postID,
      productName: post.title, 
      price: post.price.discountPrice
    )
    
    let router = PaymentRouter.paymentValidation(request: request)
    
    return service.callReqeust(with: router)
      .catch {
        let domainError = self.httpErrorToDomain(from: $0, domain: .createPost)
        return .error(domainError)
      }
  }
}
