//
//  CartPostListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/7/24.
//

import RxSwift
import RxCocoa

final class CartPostListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let checkboxTapEvent: PublishRelay<CommercialPost.PostID>
    let deleteTapEvent: PublishRelay<CommercialPost.PostID>
    let toggleAllCheckboxTapEvent: PublishRelay<Void>
    let deleteCheckPostsTapEvent: PublishRelay<Void>
    
    init(
      checkboxTapEvent: PublishRelay<CommercialPost.PostID> = .init(),
      deleteTapEvent: PublishRelay<CommercialPost.PostID> = .init(),
      toggleAllCheckboxTapEvent: PublishRelay<Void> = .init(),
      deleteCheckPostsTapEvent: PublishRelay<Void> = .init()
    ) {
      self.checkboxTapEvent = checkboxTapEvent
      self.deleteTapEvent = deleteTapEvent
      self.toggleAllCheckboxTapEvent = toggleAllCheckboxTapEvent
      self.deleteCheckPostsTapEvent = deleteCheckPostsTapEvent
    }
  }
  
  struct Output {
    let cartPosts: BehaviorRelay<[CommercialPost]>
    let checkStateList: BehaviorRelay<[CommercialPost.PostID]>
    let totalPrice: Driver<Int>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let commercialPostInteractionUsecase: any CommercialPostInteractionUsecase
  
  private let posts: BehaviorRelay<[CommercialPost]>
  private let cartPosts: BehaviorRelay<[CommercialPost]>
  private let checkStateList = BehaviorRelay<[CommercialPost.PostID]>(value: [])
  
  // MARK: - Initializer
  init(
    commercialPostInteractionUsecase: any CommercialPostInteractionUsecase,
    posts: BehaviorRelay<[CommercialPost]>,
    cartPosts: BehaviorRelay<[CommercialPost]>
  ) {
    self.commercialPostInteractionUsecase = commercialPostInteractionUsecase
    self.posts = posts
    self.cartPosts = cartPosts
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let totalPrice = BehaviorRelay<Int>(value: 0)
    
    /// 체크박스 리스트의 현재 게시물들의 가격 총합을 전달
    checkStateList
      .map { _ in self.cartPosts.value }
      .map { $0.filter { self.checkStateList.value.contains($0.postID) }}
      .map { $0.map { $0.price.discountPrice }.reduce(0, +) }
      .bind(to: totalPrice)
      .disposed(by: disposeBag)
    
    /// 체크박스 탭 이벤트 > 체크박스 리스트에 반영
    input.checkboxTapEvent
      .bind(with: self) { owner, id in
        owner.toggleCheckState(postID: id)
      }
      .disposed(by: disposeBag)
    
    /// 장바구니 false 요청 > 응답 성공 후 로컬 배열에서 삭제
    input.deleteTapEvent
      .withUnretained(self)
      .flatMap { owner, postID in
        return owner.commercialPostInteractionUsecase.removePostFromCart(postID: postID)
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return.never()
          }
      }
      .compactMap { $0 }
      .bind(with: self) { owner, post in
        owner.deletePostInCart(postID: post.postID)
      }
      .disposed(by: disposeBag)
    
    /// 전체 체크박스 탭 이벤트 > 체크박스 리스트에 반영
    input.toggleAllCheckboxTapEvent
      .bind(with: self) { owner, _ in
        owner.toggleAllCheckState()
      }
      .disposed(by: disposeBag)
    
    /// 체크박스 리스트 전체에 대해 장바구니 제거 요청 > 응답 후 로컬 배열에서 제거
    input.deleteCheckPostsTapEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.deleteCheckPostsInCart()
      }
      .bind(with: self) { owner, removedPosts in
        removedPosts.forEach {
          owner.deletePostInCart(postID: $0.postID)
        }
      }
      .disposed(by: disposeBag)
    
    return Output(
      cartPosts: cartPosts,
      checkStateList: checkStateList,
      totalPrice: totalPrice.asDriver()
    )
  }
  
  private func toggleCheckState(postID: CommercialPost.PostID) {
    
    var checkStateList = checkStateList.value
    
    defer {
      self.checkStateList.accept(checkStateList)
    }
    
    guard let index = checkStateList.firstIndex(of: postID) else {
      return checkStateList.append(postID)
    }
    
    checkStateList.remove(at: index)
  }
  
  private func deletePostInCart(postID: CommercialPost.PostID) {
    
    var cartPosts = cartPosts.value
    var checkStateList = checkStateList.value
    
    defer {
      self.cartPosts.accept(cartPosts)
      self.checkStateList.accept(checkStateList)
    }
    
    // 장바구니 리스트에서 게시물 인덱스 찾기
    guard let index = cartPosts.firstIndex(where: { $0.postID == postID }) else { return }
    
    // 장바구니 리스트에서 게시물 삭제
    cartPosts.remove(at: index)
    
    // 원본 배열의 장바구니 유저 리스트에서 사용자 본인 삭제
    removeUserFromPostInOriginalPosts(postID: postID)
    
    // 체크 게시물 리스트에 포함되어있으면, 배열에서도 삭제
    if let index = checkStateList.firstIndex(of: postID) {
      checkStateList.remove(at: index)
    }
  }
  
  private func removeUserFromPostInOriginalPosts(postID: CommercialPost.PostID) {
    
    var posts = posts.value
    
    defer { self.posts.accept(posts) }
    
    guard 
      let index = posts.firstIndex(where: { $0.postID == postID }),
      let userIndex = posts[index].shoppingCarts.firstIndex(of: UserInfoService.userID)
    else {
      return
    }
    
    posts[index].shoppingCarts.remove(at: userIndex)
  }
  
  private func toggleAllCheckState() {
    
    var checkStateList = checkStateList.value
    
    defer {
      self.checkStateList.accept(checkStateList)
    }
    
    guard cartPosts.value.count != checkStateList.count else {
      return checkStateList.removeAll()
    }
    
    checkStateList = cartPosts.value.map { $0.postID }
  }
  
  private func deleteCheckPostsInCart() -> Single<[CommercialPost]> {
    
    let removePostFromCartResults = checkStateList.value.map {
      return commercialPostInteractionUsecase.removePostFromCart(postID: $0)
        .catch {
          self.coordinator?.showErrorAlert(error: $0)
          return .just(nil)
        }
    }
    
    return Single.zip(removePostFromCartResults) {
      $0.compactMap { $0 }
    }
  }
}
