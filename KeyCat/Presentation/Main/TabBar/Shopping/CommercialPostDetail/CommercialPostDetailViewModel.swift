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
    let addCartResultToast: Driver<String>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let commercialPostInteractionUsecase: CommercialPostInteractionUsecase
  
  private let post: BehaviorRelay<CommercialPost>
  private let originalPosts: BehaviorRelay<[CommercialPost]>
  
  // MARK: - Initializer
  init(
    post: CommercialPost,
    originalPosts: BehaviorRelay<[CommercialPost]>,
    commercialPostInteractionUsecase: CommercialPostInteractionUsecase = CommercialPostInteractionUsecaseImpl()
  ) {
    let post = post.applied { $0.reviews = CommercialPost.dummyReviews }
    self.post = BehaviorRelay<CommercialPost>(value: post)
    self.originalPosts = originalPosts
    self.commercialPostInteractionUsecase = commercialPostInteractionUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let updatePostEvent = PublishRelay<Void>()
    let deletePostEvent = PublishRelay<Void>()
    let addCartResultToast = PublishRelay<String>()
    
    let addCartActionTrigger = PublishRelay<Void>()
    
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
        return owner.commercialPostInteractionUsecase.bookmark(postID: post.postID, isOn: !post.isBookmarked)
      }
      .compactMap { $0 }
      .bind(to: post)
      .disposed(by: disposeBag)
      
    input.addCartTapEvent
      .withLatestFrom(post)
      .map { $0.isAddedInCart }
      .bind { isAdded in
        if isAdded {
          addCartResultToast.accept("이미 장바구니에 추가되어있어요!")
        } else {
          addCartActionTrigger.accept(())
        }
      }
      .disposed(by: disposeBag)
    
    /// 게시물의 변경사항을 외부 원본 배열에 반영
    post
      .bind(with: self) { owner, updatedPost in
        owner.updatePostInList(updatedPost: updatedPost)
      }
      .disposed(by: disposeBag)
    
    /// 카트 추가하기 액션
    addCartActionTrigger
      .withLatestFrom(post)
      .withUnretained(self)
      .flatMap { owner, post in
        return owner.commercialPostInteractionUsecase.addCart(postID: post.postID, adding: true)
      }
      .compactMap { $0 }
      .do(onNext: { _ in addCartResultToast.accept("상품이 장바구니에 추가되었어요!") })
      .bind(to: post)
      .disposed(by: disposeBag)
    
    return Output(
      post: post.asDriver(),
      addCartResultToast: addCartResultToast.asDriver(onErrorJustReturn: "")
    )
  }
  
  private func updatePostInList(updatedPost: CommercialPost) {
    var currentPosts = originalPosts.value
    
    guard let index = currentPosts.firstIndex(where: { $0.postID == updatedPost.postID }) else { return }
    
    currentPosts[index] = updatedPost
    originalPosts.accept(currentPosts)
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
