//
//  IamportPayment+.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import Foundation
import iamport_ios

extension IamportPayment {
  
  static func standard(post: CommercialPost) -> IamportPayment {
    
    return IamportPayment(
      pg: PG.html5_inicis.makePgRawName(pgId: Constant.Payment.pgID),
      merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date.now.timeIntervalSince1970))",
      amount: "\(post.price.discountPrice)"
    ).then {
      $0.pay_method = PayMethod.card.rawValue
      $0.name = post.title
      $0.buyer_name = Constant.Payment.buyerName
      $0.app_scheme = Constant.Payment.appScheme
    }
  }
}
