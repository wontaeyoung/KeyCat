//
//  PaymentViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/8/24.
//

import RxSwift
import RxCocoa
import iamport_ios

final class PaymentViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    let responseReceivedEvent: PublishRelay<IamportResponse?>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init(),
      responseReceivedEvent: PublishRelay<IamportResponse?> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
      self.responseReceivedEvent = responseReceivedEvent
    }
  }
  
  struct Output {
    let paymentInfo: Driver<(userCode: String, payment: IamportPayment)>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let paymentUsecase: PaymentUsecase
  private let post: CommercialPost
  
  private let paidSuccessTrigger: PublishRelay<Void>
  
  // MARK: - Initializer
  init(
    post: CommercialPost,
    paymentUsecase: PaymentUsecase = PaymentUsecaseImpl(),
    paidSuccessTrigger: PublishRelay<Void>
  ) {
    self.post = post
    self.paymentUsecase = paymentUsecase
    self.paidSuccessTrigger = paidSuccessTrigger
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let paymentInfo: (userCode: String, payment: IamportPayment) = (Constant.Payment.userCode, .standard(post: post))
    let paymentInfoRelay = BehaviorRelay(value: paymentInfo)
    let paymentValidationTrigger = PublishRelay<IamportResponse>()
    
    /// 화면 로드 > 결제 요청
    input.viewDidLoadEvent
      .map { paymentInfo }
      .bind(to: paymentInfoRelay)
      .disposed(by: disposeBag)
    
    /// 결제 응답 결과 필터링 > 영수증 검증 트리거 전달
    input.responseReceivedEvent
      .withUnretained(self)
      .flatMap { owner, response in
        guard let response else {
          return Single<IamportResponse>.error(KCError.invalidPaymentResponse)
            .catch {
              owner.coordinator?.showErrorAlert(error: $0)
              return .never()
            }
        }
        
        return .just(response)
      }
      .bind(to: paymentValidationTrigger)
      .disposed(by: disposeBag)
    
    /// 결제 영수증 검증 요청 > 실패 시 에러 안내 후 pop > 성공 시 트리거를 통해서 상품뷰로 이벤트 전달
    paymentValidationTrigger
      .withUnretained(self)
      .flatMap { owner, response in
        return owner.paymentUsecase.valid(post: owner.post, impUID: response.imp_uid ?? .defaultValue)
          .catch {
            owner.coordinator?.showErrorAlert(error: $0) {
              owner.coordinator?.pop()
            }
            return .never()
          }
      }
      .bind(to: paidSuccessTrigger)
      .disposed(by: disposeBag)
    
    /// 결제 성공하면 화면 pop
    paidSuccessTrigger
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
  
    return Output(paymentInfo: paymentInfoRelay.asDriver())
  }
}
