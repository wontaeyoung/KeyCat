//
//  PaymentRepository.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import Foundation
import RxSwift

protocol PaymentRepository {
  
  func validPayment(post: CommercialPost, impUID: String) -> Single<Void>
}
