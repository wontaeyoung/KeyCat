//
//  CreateCommercialReviewViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import RxSwift
import RxCocoa

final class CreateCommercialReviewViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let reviewRating: BehaviorRelay<CommercialReview.Rating>
    let content: BehaviorRelay<String>
    let createTapEvent: PublishRelay<Void>
    let toastCompleteEvent: PublishRelay<Void>
    
    init(
      reviewRating: BehaviorRelay<CommercialReview.Rating> = .init(value: .coalesce),
      content: BehaviorRelay<String> = .init(value: .defaultValue),
      createTapEvent: PublishRelay<Void> = .init(),
      toastCompleteEvent: PublishRelay<Void> = .init()
    ) {
      self.reviewRating = reviewRating
      self.content = content
      self.createTapEvent = createTapEvent
      self.toastCompleteEvent = toastCompleteEvent
    }
  }
  
  struct Output {
    let post: Driver<CommercialPost>
    let reviewRating: Driver<CommercialReview.Rating>
    let createButtonEnable: Driver<Bool>
    let reviewCreatedToast: Driver<Void>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  private let createReviewUsecase: any CreateReviewUsecase
  
  private var post: CommercialPost
  private let reviews: BehaviorRelay<[CommercialReview]>
  private let review = PublishRelay<CommercialReview>()
  
  // MARK: - Initializer
  init(
    createReviewUsecase: any CreateReviewUsecase,
    post: CommercialPost,
    reviews: BehaviorRelay<[CommercialReview]>
  ) {
    self.createReviewUsecase = createReviewUsecase
    self.post = post
    self.reviews = reviews
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let createButtonEnable = BehaviorRelay<Bool>(value: false)
    let reviewCreatedToast = PublishRelay<Void>()
    
    /// 새로 추가된 리뷰를 원본 배열에 반영
    review
      .bind(with: self) { owner, newReview in
        owner.insertReviewInList(newReview: newReview)
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 내용 최소길이 검사
    input.content
      .map { $0.count >= BusinessValue.Product.minReviewContentLength }
      .bind(to: createButtonEnable)
      .disposed(by: disposeBag)
    
    /// 리뷰 작성 로직 호출
    input.createTapEvent
      .map { self.makeReview(input: input) }
      .withUnretained(self)
      .flatMap { owner, review in
        return owner.createReviewUsecase.execute(postID: owner.post.postID, review: review)
      }
      .compactMap { $0 }
      .do(onNext: { _ in reviewCreatedToast.accept(()) })
      .bind(to: review)
      .disposed(by: disposeBag)
    
    /// 토스트가 완료되면 뒤로가기
    input.toastCompleteEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
    
    return Output(
      post: .just(post),
      reviewRating: input.reviewRating.asDriver(),
      createButtonEnable: createButtonEnable.asDriver(),
      reviewCreatedToast: reviewCreatedToast.asDriver(onErrorJustReturn: ())
    )
  }
  
  private func makeReview(input: Input) -> CommercialReview {
    
    return CommercialReview(
      reviewID: .defaultValue,
      content: input.content.value,
      rating: input.reviewRating.value,
      createdAt: .now,
      creator: .empty
    )
  }
  
  private func insertReviewInList(newReview: CommercialReview) {
    var currentReviews = reviews.value
    currentReviews.insert(newReview, at: 0)
    reviews.accept(currentReviews)
  }
}
