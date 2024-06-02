//
//  DIContainer.swift
//  KeyCat
//
//  Created by 원태영 on 6/1/24.
//

import Alamofire

final class DIContainer {
  
  private init() { }
  
  // MARK: - Network
  static let apiRequestInterceptor: APIRequestInterceptor = APIRequestInterceptor()
  static let apiEventMonitor: APIEventMonitor = APIEventMonitor()
  static let session = Session(interceptor: apiRequestInterceptor, eventMonitors: [apiEventMonitor])
  static let apiService: APIService = APIService(session: session)
  
  // MARK: - Repository
  static let authRepository: some AuthRepository = AuthRepositoryImpl()
  static let userRepository: some UserRepository = UserRepositoryImpl()
  static let chatRepository: some ChatRepository = ChatRepositoryImpl()
  static let postRepository: some PostRepository = PostRepositoryImpl()
  static let paymentRepository: some PaymentRepository = PaymentRepositoryImpl()
  static let reviewRepository: some ReviewRepository = ReviewRepositoryImpl()
  
  // MARK: - Usecase
  static let checkEmailValidationUsecase: some CheckEmailDuplicationUsecase = CheckEmailDuplicationUsecaseImpl(authRepository: authRepository)
  static let authenticateBusinessInfoUsecase: some AuthenticateBusinessInfoUsecase = AuthenticateBusinessInfoUsecaseImpl(authRepository: authRepository)
  static let signUsecase: some SignUsecase = SignUsecaseImpl(
    authRepository: authRepository,
    userRepository: userRepository
  )
  static let profileUsecase: some ProfileUsecase = ProfileUsecaseImpl(userRepository: userRepository)
  static let fetchCommercialPostUsecase: some FetchCommercialPostUsecase = FetchCommercialPostUsecaseImpl(postRepository: postRepository)
  static let commercialPostInteractionUsecase: some CommercialPostInteractionUsecase = CommercialPostInteractionUsecaseImpl(postRepository: postRepository)
  static let handleCommercialPostUsecase: some HandleCommercialPostUsecase = HandleCommercialPostUsecaseImpl(postRepository: postRepository)
  static let paymentUsecase: some PaymentUsecase = PaymentUsecaseImpl(paymentRepository: paymentRepository)
  static let createPostUsecase: some CreatePostUsecase = CreatePostUsecaseImpl(postRepository: postRepository)
  static let createReviewUsecase: some CreateReviewUsecase = CreateReviewUsecaseImpl(reviewRepository: reviewRepository)
  static let handleReviewUsecase: some HandleReviewUsecase = HandleReviewUsecaseImpl(reviewRepository: reviewRepository)
  static let chatRoomUsecase: some ChatRoomUsecase = ChatRoomUsecaseImpl(chatRepository: chatRepository)
  static let fetchProfileUsecase: some ProfileUsecase = ProfileUsecaseImpl(userRepository: userRepository)
  static let userInteractionUsecase: some UserInteractionUsecase = UserInteractionUsecaseImpl(userRepository: userRepository)
}
