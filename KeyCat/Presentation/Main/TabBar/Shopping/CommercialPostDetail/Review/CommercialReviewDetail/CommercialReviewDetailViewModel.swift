//
//  CommercialReviewDetailViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class CommercialReviewDetailViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let profileTapEvent: PublishRelay<Void>
    let handleReviewAction: PublishRelay<HandleContentAction>
    let toastCompleteEvent: PublishRelay<Void>
    
    init(
      profileTapEvent: PublishRelay<Void> = .init(),
      handleReviewAction: PublishRelay<HandleContentAction> = .init(),
      toastCompleteEvent: PublishRelay<Void> = .init()
    ) {
      self.profileTapEvent = profileTapEvent
      self.handleReviewAction = handleReviewAction
      self.toastCompleteEvent = toastCompleteEvent
    }
  }
  
  struct Output {
    let review: Driver<CommercialReview>
    let reviewDeletedToast: Driver<Void>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  private let handleReviewUsecase: HandleReviewUsecase
  
  private let postID: CommercialPost.PostID
  private let review: BehaviorRelay<CommercialReview>
  private let reviews: BehaviorRelay<[CommercialReview]>
  
  // MARK: - Initializer
  init(
    postID: CommercialPost.PostID,
    review: CommercialReview,
    reviews: BehaviorRelay<[CommercialReview]>,
    handleReviewUsecase: HandleReviewUsecase = HandleReviewUsecaseImpl()
  ) {
    self.postID = postID
    self.review = BehaviorRelay(value: review)
    self.reviews = reviews
    self.handleReviewUsecase = handleReviewUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let updateReviewEvent = PublishRelay<Void>()
    let deleteReviewEvent = PublishRelay<Void>()
    let reviewDeletedToast = PublishRelay<Void>()
    
    /// 리뷰 삭제 팝업 확인 > 리뷰 삭제 로직 호출
    deleteReviewEvent
      .withLatestFrom(review)
      .withUnretained(self)
      .flatMap { owner, review in
        return owner.handleReviewUsecase.deleteReview(postID: owner.postID, reviewID: review.reviewID)
      }
      .bind(to: reviewDeletedToast)
      .disposed(by: disposeBag)
    
    /// 리뷰 삭제 성공 > 원본 배열에 반영
    reviewDeletedToast
      .bind(with: self) { owner, _ in
        owner.deleteReviewFromReviews()
      }
      .disposed(by: disposeBag)
    
    /// 게시글 변경 이벤트 핸들링
    input.handleReviewAction
      .bind(with: self) { owner, action in
        switch action {
          case .update:
            updateReviewEvent.accept(())
          case .delete:
            owner.showDeleteReviewAlert(deleteReviewEvent)
        }
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 삭제 토스트 완료 > 뒤로가기
    input.toastCompleteEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
    
    return Output(
      review: review.asDriver(),
      reviewDeletedToast: reviewDeletedToast.asDriver(onErrorJustReturn: ())
    )
  }
  
  private func deleteReviewFromReviews() {
    var reviews = reviews.value
    guard let index = reviews.firstIndex(where: { $0.reviewID == review.value.reviewID }) else { return }
    
    reviews.remove(at: index)
    self.reviews.accept(reviews)
  }
  
  private func showDeleteReviewAlert(_ event: PublishRelay<Void>) {
    
    coordinator?.showAlert(
      title: "리뷰 삭제",
      message: "삭제한 리뷰는 다시 복구할 수 없어요. 정말 삭제할까요?",
      okStyle: .destructive,
      isCancelable: true
    ) {
      event.accept(())
    }
  }
}
