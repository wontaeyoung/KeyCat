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
    
  }
  
  struct Output {
    let reviews: Driver<[CommercialReview]>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ReviewCoordinator?
  
  // MARK: - Initializer
  init() {
    
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output(
      reviews: Driver.just(CommercialPost.dummyReviews)
    )
  }
}

