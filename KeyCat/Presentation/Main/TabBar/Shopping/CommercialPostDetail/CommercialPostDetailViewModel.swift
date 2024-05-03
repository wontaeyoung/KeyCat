//
//  CommercialPostDetailViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/2/24.
//

import RxSwift
import RxCocoa

final class CommercialPostDetailViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let handlePostAction: PublishRelay<HandlePostAction>
    
    init(handlePostAction: PublishRelay<HandlePostAction> = .init()) {
      self.handlePostAction = handlePostAction
    }
  }
  
  struct Output {
    let post: Driver<CommercialPost>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let post: BehaviorRelay<CommercialPost>
  
  // MARK: - Initializer
  init(post: CommercialPost) {
    let post = post.applied { $0.reviews = CommercialPost.dummyReviews }
    self.post = BehaviorRelay<CommercialPost>(value: post)
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    return Output(post: post.asDriver())
  }
}
