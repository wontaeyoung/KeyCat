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
  
  static let checkEmailValidationUsecase: some CheckEmailDuplicationUsecase = CheckEmailDuplicationUsecaseImpl()
  static let authenticateBusinessInfoUsecase: some AuthenticateBusinessInfoUsecase = AuthenticateBusinessInfoUsecaseImpl()
  static let signUsecase: some SignUsecase = SignUsecaseImpl()
  static let profileUsecase: some ProfileUsecase = ProfileUsecaseImpl()
  static let fetchCommercialPostUsecase: some FetchCommercialPostUsecase = FetchCommercialPostUsecaseImpl()
  static let commercialPostInteractionUsecase: some CommercialPostInteractionUsecase = CommercialPostInteractionUsecaseImpl()
  static let handleCommercialPostUsecase: some HandleCommercialPostUsecase = HandleCommercialPostUsecaseImpl()
  static let paymentUsecase: some PaymentUsecase = PaymentUsecaseImpl()
  static let createPostUsecase: some CreatePostUsecase = CreatePostUsecaseImpl()
  static let createReviewUsecase: some CreateReviewUsecase = CreateReviewUsecaseImpl()
  static let handleReviewUsecase: some HandleReviewUsecase = HandleReviewUsecaseImpl()
  static let chatRoomUsecase: some ChatRoomUsecase = ChatRoomUsecaseImpl()
}
