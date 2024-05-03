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
    let sellerProfileTapEvent: PublishRelay<Void>
    let bookmarkTapEvent: PublishRelay<Void>
    let reviewTapEvent: PublishRelay<Void>
    let addCartTapEvent: PublishRelay<Void>
    let buyingTapEvent: PublishRelay<Void>
    
    init(
      handlePostAction: PublishRelay<HandlePostAction> = .init(),
      sellerProfileTapEvent: PublishRelay<Void> = .init(),
      bookmarkTapEvent: PublishRelay<Void> = .init(),
      reviewTapEvent: PublishRelay<Void> = .init(),
      addCartTapEvent: PublishRelay<Void> = .init(),
      buyingTapEvent: PublishRelay<Void> = .init()
    ) {
      self.handlePostAction = handlePostAction
      self.sellerProfileTapEvent = sellerProfileTapEvent
      self.bookmarkTapEvent = bookmarkTapEvent
      self.reviewTapEvent = reviewTapEvent
      self.addCartTapEvent = addCartTapEvent
      self.buyingTapEvent = buyingTapEvent
    }
  }
  
  struct Output {
    let post: Driver<CommercialPost>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let bookmarkUsecase: BookmarkUsecase
  
  private let post: BehaviorRelay<CommercialPost>
  
  // MARK: - Initializer
  init(
    post: CommercialPost,
    bookmarkUsecase: BookmarkUsecase = BookmarkUsecaseImpl()
  ) {
    let post = post.applied { $0.reviews = CommercialPost.dummyReviews }
    self.post = BehaviorRelay<CommercialPost>(value: post)
    self.bookmarkUsecase = bookmarkUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let updatePostEvent = PublishRelay<Void>()
    let deletePostEvent = PublishRelay<Void>()
    
    /// 게시글 변경 이벤트 핸들링
    input.handlePostAction
      .bind(with: self) { owner, action in
        switch action {
          case .update:
            updatePostEvent.accept(())
          case .delete:
            owner.showDeletePostAlert(deletePostEvent)
        }
      }
      .disposed(by: disposeBag)
    
    /// 북마크 > 포스트 갱신
    input.bookmarkTapEvent
      .withLatestFrom(post)
      .withUnretained(self)
      .flatMap { owner, post in
        return owner.bookmarkUsecase.execute(postID: post.postID, isOn: !post.isBookmarked)
      }
      .compactMap { $0 }
      .bind(to: post)
      .disposed(by: disposeBag)
      
      
    
    return Output(
      post: post.asDriver()
    )
  }
  
  private func showDeletePostAlert(_ event: PublishRelay<Void>) {
    
    coordinator?.showAlert(
      title: "게시글 삭제",
      message: "삭제한 게시글은 다시 복구할 수 없어요. 정말 삭제할까요?",
      okStyle: .destructive,
      isCancelable: true
    ) {
      event.accept(())
    }
  }
}
