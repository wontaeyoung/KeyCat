//
//  DIContainer.swift
//  KeyCat
//
//  Created by 원태영 on 6/1/24.
//

import Alamofire

final class DIContainer {
  
  static let apiRequestInterceptor: APIRequestInterceptor = APIRequestInterceptor()
  static let apiEventMonitor: APIEventMonitor = APIEventMonitor()
  static let session = Session(interceptor: apiRequestInterceptor, eventMonitors: [apiEventMonitor])
  static let apiService: APIService = APIService(session: session)
}
