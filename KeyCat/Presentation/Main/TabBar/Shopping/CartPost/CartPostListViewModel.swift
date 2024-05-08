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
    let posts: BehaviorRelay<[CommercialPost]>
    let checkStateList: BehaviorRelay<[CommercialPost.PostID]>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let commercialPostInteractionUsecase: CommercialPostInteractionUsecase
  
  private let cartPosts: BehaviorRelay<[CommercialPost]>
  private let checkStateList = BehaviorRelay<[CommercialPost.PostID]>(value: [])
  
  // MARK: - Initializer
  init(
    cartPosts: BehaviorRelay<[CommercialPost]>,
    commercialPostInteractionUsecase: CommercialPostInteractionUsecase = CommercialPostInteractionUsecaseImpl()
  ) {
    self.cartPosts = cartPosts
    self.commercialPostInteractionUsecase = commercialPostInteractionUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
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
    
    return Output(
      posts: cartPosts,
      checkStateList: checkStateList
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
    
    var posts = cartPosts.value
    var checkStateList = checkStateList.value
    
    defer {
      self.cartPosts.accept(posts)
      self.checkStateList.accept(checkStateList)
    }
    
    guard let index = posts.firstIndex(where: { $0.postID == postID }) else { return }
    
    posts.remove(at: index)
    
    if let index = checkStateList.firstIndex(of: postID) {
      checkStateList.remove(at: index)
    }
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
}
