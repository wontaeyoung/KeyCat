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
  
  // MARK: - Mapper
  static let postMapper: PostMapper = PostMapper(
    userMapper: userMapper,
    commentMapper: commentMapper
  )
  static let commentMapper: CommentMapper = CommentMapper(userMapper: userMapper)
  static let userMapper: UserMapper = UserMapper()
  static let chatMapper: ChatMapper = ChatMapper(userMapper: userMapper)
  static let paymentMapper: PaymentMapper = PaymentMapper()
  
  // MARK: - Repository
  static let authRepository: some AuthRepository = AuthRepositoryImpl(
    service: apiService,
    userMapper: userMapper
  )
  static let userRepository: some UserRepository = UserRepositoryImpl(
    service: apiService,
    userMapper: userMapper
  )
  static let chatRepository: some ChatRepository = ChatRepositoryImpl(
    service: apiService,
    chatMapper: chatMapper
  )
  static let postRepository: some PostRepository = PostRepositoryImpl(
    service: apiService,
    postMapper: postMapper
  )
  static let paymentRepository: some PaymentRepository = PaymentRepositoryImpl(
    service: apiService,
    paymentMapper: paymentMapper
  )
  static let reviewRepository: some ReviewRepository = ReviewRepositoryImpl(
    service: apiService,
    commentMapper: commentMapper
  )
  
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
