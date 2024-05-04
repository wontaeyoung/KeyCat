//
//  ReviewListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/4/24.
//

import RxSwift
import RxCocoa

final class ReviewListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let backTapEvent: PublishRelay<Void>
    let createReviewTapEvent: PublishRelay<Void>
    
    init(
      backTapEvent: PublishRelay<Void> = .init(),
      createReviewTapEvent: PublishRelay<Void> = .init()
    ) {
      self.backTapEvent = backTapEvent
      self.createReviewTapEvent = createReviewTapEvent
    }
  }
  
  struct Output {
    let reviews: Driver<[CommercialReview]>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  private let post: CommercialPost
  
  // MARK: - Initializer
  init(post: CommercialPost) {
    self.post = post
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    /// 리뷰 코디네이터 해제를 위해 커스텀 Back 버튼 동작
    input.backTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
        owner.coordinator?.end()
      }
      .disposed(by: disposeBag)
    
    /// 리뷰 작성 이벤트 > 리뷰 작성 화면 연결
    input.createReviewTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showCreateCommercialReviewView(post: owner.post)
      }
      .disposed(by: disposeBag)
    
    return Output(
      reviews: Driver.just(CommercialPost.dummyReviews)
    )
  }
}
