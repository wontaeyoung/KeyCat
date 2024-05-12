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
    let handlePostAction: PublishRelay<HandleContentAction>
    let sellerProfileTapEvent: PublishRelay<User>
    let bookmarkTapEvent: PublishRelay<Void>
    let reviewTapEvent: PublishRelay<Void>
    let addCartTapEvent: PublishRelay<Void>
    let buyingTapEvent: PublishRelay<Void>
    let toastCompleteEvent: PublishRelay<Void>
    let cartShortCutTapEvent: PublishRelay<Void>
    
    init(
      handlePostAction: PublishRelay<HandleContentAction> = .init(),
      sellerProfileTapEvent: PublishRelay<User> = .init(),
      bookmarkTapEvent: PublishRelay<Void> = .init(),
      reviewTapEvent: PublishRelay<Void> = .init(),
      addCartTapEvent: PublishRelay<Void> = .init(),
      buyingTapEvent: PublishRelay<Void> = .init(),
      toastCompleteEvent: PublishRelay<Void> = .init(),
      cartShortCutTapEvent: PublishRelay<Void> = .init()
    ) {
      self.handlePostAction = handlePostAction
      self.sellerProfileTapEvent = sellerProfileTapEvent
      self.bookmarkTapEvent = bookmarkTapEvent
      self.reviewTapEvent = reviewTapEvent
      self.addCartTapEvent = addCartTapEvent
      self.buyingTapEvent = buyingTapEvent
      self.toastCompleteEvent = toastCompleteEvent
      self.cartShortCutTapEvent = cartShortCutTapEvent
    }
  }
  
  struct Output {
    let post: Driver<CommercialPost>
    let isBookmark: Driver<Bool>
    let bookmarkCount: Driver<Int>
    let addCartResultToast: Driver<String>
    let postDeletedToast: Driver<Void>
    let postPaidToast: Driver<Void>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let commercialPostInteractionUsecase: CommercialPostInteractionUsecase
  private let handleCommercialPostUsecase: HandleCommercialPostUsecase
  
  private let post: BehaviorRelay<CommercialPost>
  private let originalPosts: BehaviorRelay<[CommercialPost]>
  private let cartPosts: BehaviorRelay<[CommercialPost]>
  private let paidSuccessTrigger = PublishRelay<Void>()
  
  // MARK: - Initializer
  init(
    post: CommercialPost,
    originalPosts: BehaviorRelay<[CommercialPost]>,
    cartPosts: BehaviorRelay<[CommercialPost]>,
    commercialPostInteractionUsecase: CommercialPostInteractionUsecase = CommercialPostInteractionUsecaseImpl(),
    handleCommercialPostUsecase: HandleCommercialPostUsecase = HandleCommercialPostUsecaseImpl()
  ) {
    self.post = BehaviorRelay<CommercialPost>(value: post)
    self.originalPosts = originalPosts
    self.cartPosts = cartPosts
    self.commercialPostInteractionUsecase = commercialPostInteractionUsecase
    self.handleCommercialPostUsecase = handleCommercialPostUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let addCartResultToast = PublishRelay<String>()
    let postDeletedToast = PublishRelay<Void>()
    let postPaidToast = PublishRelay<Void>()
    let isBookmark = BehaviorRelay<Bool>(value: post.value.isBookmarked)
    let bookmarkCount = BehaviorRelay<Int>(value: post.value.bookmarks.count)
    
    let updatePostEvent = PublishRelay<Void>()
    let deletePostEvent = PublishRelay<Void>()
    
    let addCartActionTrigger = PublishRelay<Void>()
    let addedCartPost = PublishRelay<CommercialPost>()
    
    /// 게시물 삭제 > 원본 데이터 반영 > 삭제 완료 토스트 전달
    deletePostEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.handleCommercialPostUsecase.deletePost(postID: owner.post.value.postID)
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .do(onNext: { [weak self] in
        guard let self else { return }
        removePostInList(removedPost: post.value)
      })
      .bind(to: postDeletedToast)
      .disposed(by: disposeBag)
    
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
    
    /// 판매자 프로필 탭 > 프로필 화면 연결
    input.sellerProfileTapEvent
      .bind(with: self) { owner, user in
        owner.coordinator?.connectProfileFlow(user: user)
      }
      .disposed(by: disposeBag)
    
    /// 북마크 요청 > 포스트 갱신
    input.bookmarkTapEvent
      .do(onNext: { _ in
        // 옵티미스틱
        let addingCount = isBookmark.value ? -1 : 1
        let updatedBookmark = !isBookmark.value
        
        bookmarkCount.accept(bookmarkCount.value + addingCount)
        isBookmark.accept(updatedBookmark)
        
      })
      .debounce(.seconds(2), scheduler: MainScheduler.instance)
      .withLatestFrom(post)
      .withUnretained(self)
      .flatMap { owner, post in
        return owner.commercialPostInteractionUsecase.bookmark(postID: post.postID, isOn: !post.isBookmarked)
      }
      .compactMap { $0 }
      .bind(to: post)
      .disposed(by: disposeBag)
    
    /// 리뷰 탭 이벤트 > 리뷰 화면 연결
    input.reviewTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.connectReviewFlow(post: owner.post)
      }
      .disposed(by: disposeBag)
    
    /// 장바구니 추가 이벤트 > 이미 추가되어있는지 체크 > 액션 분기 처리
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
    
    /// 토스트 완료 이벤트 > 화면 뒤로가기
    input.toastCompleteEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)
    
    /// 장바구니 바로가기 화면 연결
    input.cartShortCutTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss()
        owner.coordinator?.showCartPostListView(posts: owner.originalPosts, cartPosts: owner.cartPosts)
      }
      .disposed(by: disposeBag)
    
    input.buyingTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showPaymentView(post: owner.post.value, paidSuccessTrigger: owner.paidSuccessTrigger)
      }
      .disposed(by: disposeBag)
    
    /// 게시물의 변경사항을 외부 원본 배열에 반영
    post
      .bind(with: self) { owner, updatedPost in
        owner.updatePostInList(updatedPost: updatedPost)
      }
      .disposed(by: disposeBag)
    
    /// 게시물 원본의 북마크 변경사항 반영
    post
      .map { $0.isBookmarked }
      .bind(to: isBookmark)
      .disposed(by: disposeBag)
    
    /// 게시물 원본의 북마크 갯수 반영
    post
      .map { $0.bookmarks.count }
      .bind(to: bookmarkCount)
      .disposed(by: disposeBag)
    
    /// 카트에 추가된 게시물을 외부 원본 배열에 반영
    addedCartPost
      .bind(with: self) { owner, post in
        owner.addPostInCart(addedPost: post)
      }
      .disposed(by: disposeBag)
    
    /// 카트 추가하기 액션
    addCartActionTrigger
      .withLatestFrom(post)
      .withUnretained(self)
      .flatMap { owner, post in
        return owner.commercialPostInteractionUsecase.addPostInCart(postID: post.postID)
      }
      .compactMap { $0 }
      .do(onNext: { [weak self] in
        guard let self else { return }
        
        addedCartPost.accept($0)
        coordinator?.presentCartPostListSheet(cartPosts: cartPosts, viewModel: self)
      })
      .bind(to: post)
      .disposed(by: disposeBag)
    
    /// 결제 성공 > 게시물 구매자 리스트에 유저 본인 추가
    paidSuccessTrigger
      .bind(with: self) { owner, _ in
        owner.processBuyingProduct()
        postPaidToast.accept(())
      }
      .disposed(by: disposeBag)
    
    return Output(
      post: post.asDriver(),
      isBookmark: isBookmark.asDriver(),
      bookmarkCount: bookmarkCount.asDriver(),
      addCartResultToast: addCartResultToast.asDriver(onErrorJustReturn: ""),
      postDeletedToast: postDeletedToast.asDriver(onErrorJustReturn: ()),
      postPaidToast: postPaidToast.asDriver(onErrorJustReturn: ())
    )
  }
  
  private func processBuyingProduct() {
    makeUserAsBuyer()
    removePostFromCart()
  }
  
  private func makeUserAsBuyer() {
    guard post.value.buyers.contains(UserInfoService.userID) == false else { return }
    
    let post = post.value.applied {
      $0.buyers.append(UserInfoService.userID)
    }
    
    self.post.accept(post)
  }
  
  private func updatePostInList(updatedPost: CommercialPost) {
    var currentPosts = originalPosts.value
    
    guard let index = currentPosts.firstIndex(where: { $0.postID == updatedPost.postID }) else { return }
    
    currentPosts[index] = updatedPost
    originalPosts.accept(currentPosts)
  }
  
  private func removePostInList(removedPost: CommercialPost) {
    var currentPosts = originalPosts.value
    
    guard let index = currentPosts.firstIndex(where: { $0.postID == removedPost.postID }) else { return }
    
    currentPosts.remove(at: index)
    originalPosts.accept(currentPosts)
  }
  
  /// 카트 추가하기
  private func addPostInCart(addedPost: CommercialPost) {
    var cartPosts = cartPosts.value
    cartPosts.insert(addedPost, at: 0)
    
    self.cartPosts.accept(cartPosts)
  }
  
  /// 카트에서 삭제하기
  private func removePostFromCart() {
    var cartPosts = cartPosts.value
    
    guard let index = cartPosts.firstIndex(where: { $0.postID == post.value.postID }) else {
      return
    }
    
    cartPosts.remove(at: index)
    
    self.cartPosts.accept(cartPosts)
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
