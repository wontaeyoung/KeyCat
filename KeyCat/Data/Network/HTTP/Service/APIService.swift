//
//  APIService.swift
//  KeyCat
//
//  Created by 원태영 on 4/16/24.
//

import Alamofire
import RxAlamofire
import RxSwift

struct APIService {
  
  private let session = Session(eventMonitors: [APIEventMonitor.shared])
  
  func callRequest<T: HTTPResponse>(with router: Router, of type: T.Type) -> Single<T> {
    return session
      .request(router)
      .rx
      .call(of: T.self)
  }
}
