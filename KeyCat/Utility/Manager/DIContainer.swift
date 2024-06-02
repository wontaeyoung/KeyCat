//
//  DIContainer.swift
//  KeyCat
//
//  Created by 원태영 on 6/1/24.
//

import Alamofire

final class DIContainer {
  
  private init() { }
  
  static let apiRequestInterceptor: APIRequestInterceptor = APIRequestInterceptor()
  static let apiEventMonitor: APIEventMonitor = APIEventMonitor()
  static let session = Session(interceptor: apiRequestInterceptor, eventMonitors: [apiEventMonitor])
  static let apiService: APIService = APIService(session: session)
  
  static let checkEmailValidationUsecase: any CheckEmailDuplicationUsecase = CheckEmailDuplicationUsecaseImpl()
  static let authenticateBusinessInfoUsecase: any AuthenticateBusinessInfoUsecase = AuthenticateBusinessInfoUsecaseImpl()
  static let signUsecase: any SignUsecase = SignUsecaseImpl()
  static let profileUsecase: any ProfileUsecase = ProfileUsecaseImpl()
  static let fetchCommercialPostUsecase: any FetchCommercialPostUsecase = FetchCommercialPostUsecaseImpl()
}
