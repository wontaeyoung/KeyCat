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
    
    init(
      reviewRating: BehaviorRelay<CommercialReview.Rating> = .init(value: .coalesce),
      content: BehaviorRelay<String> = .init(value: .defaultValue),
      createTapEvent: PublishRelay<Void> = .init()
    ) {
      self.reviewRating = reviewRating
      self.content = content
      self.createTapEvent = createTapEvent
    }
  }
  
  struct Output {
    let post: Driver<CommercialPost>
    let reviewRating: Driver<CommercialReview.Rating>
    let createButtonEnable: Driver<Bool>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  
  private var post: CommercialPost
  
  // MARK: - Initializer
  init(post: CommercialPost) {
    self.post = post
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let createButtonEnable = BehaviorRelay<Bool>(value: false)
    
    /// 리뷰 내용 최소길이 검사
    input.content
      .map { $0.count >= BusinessValue.Product.minReviewContentLength }
      .bind(to: createButtonEnable)
      .disposed(by: disposeBag)
    
    return Output(
      post: .just(post),
      reviewRating: input.reviewRating.asDriver(),
      createButtonEnable: createButtonEnable.asDriver()
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
}
