//
//  PaymentRouter.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import Foundation
import Alamofire

enum PaymentRouter: Router {
  
  case paymentValidation(request: PaymentValidationRequest)
  case myPayments
  
  var method: HTTPMethod {
    switch self {
      case .paymentValidation:
        return .post
        
      case .myPayments:
        return .get
    }
  }
  
  var path: String {
    switch self {
      case .paymentValidation:
        return "/payments/validation"
        
      case .myPayments:
        return "/payments/me"
    }
  }
  
  var optionalHeaders: HTTPHeaders {
    switch self {
      case .paymentValidation, .myPayments:
        return [
          HTTPHeader(name: KCHeader.Key.authorization, value: UserInfoService.accessToken),
          HTTPHeader(name: KCHeader.Key.contentType, value: KCHeader.Value.applicationJson)
        ]
    }
  }
  
  var parameters: Parameters? {
    switch self {
      case .paymentValidation, .myPayments:
        return nil
    }
  }
  
  var body: Data? {
    switch self {
      case .paymentValidation(let request):
        return requestToBody(request)
        
      case .myPayments:
        return nil
    }
  }
}
