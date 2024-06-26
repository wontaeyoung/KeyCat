//
//  ShoppingViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    let createPostTapEvent: PublishRelay<Void>
    let cartTapEvent: PublishRelay<Void>
    let showProductCellEvent: PublishRelay<IndexPath>
    let postCollectionCellSelectedEvent: PublishRelay<CommercialPost>
    let scrollRefeshEvent: PublishRelay<Void>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init(),
      createPostTapEvent: PublishRelay<Void> = .init(),
      cartTapEvent: PublishRelay<Void> = .init(),
      showProductCellEvent: PublishRelay<IndexPath> = .init(),
      postCollectionCellSelectedEvent: PublishRelay<CommercialPost> = .init(),
      scrollRefeshEvent: PublishRelay<Void> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
      self.createPostTapEvent = createPostTapEvent
      self.cartTapEvent = cartTapEvent
      self.showProductCellEvent = showProductCellEvent
      self.postCollectionCellSelectedEvent = postCollectionCellSelectedEvent
      self.scrollRefeshEvent = scrollRefeshEvent
    }
  }
  
  struct Output {
    let hasSellerAuthority: Driver<Bool>
    let posts: Driver<[CommercialPost]>
    let cartPosts: Driver<[CommercialPost]>
    let refreshCompleted: Driver<Void>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: ShoppingCoordinator?
  private let fetchCommercialPostsUsecase: any FetchCommercialPostUsecase
  
  private var nextCursor: CommercialPost.PostID = ""
  private let fetchedPosts = PublishRelay<[CommercialPost]>()
  private let posts = BehaviorRelay<[CommercialPost]>(value: [])
  private let cartPosts = BehaviorRelay<[CommercialPost]>(value: [])
  
  // MARK: - Initializer
  init(fetchCommercialPostsUsecase: any FetchCommercialPostUsecase) {
    self.fetchCommercialPostsUsecase = fetchCommercialPostsUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let fetchNextPostsTrigger = PublishRelay<Void>()
    let hasSellerAuthority = PublishRelay<Bool>()
    let refreshCompleted = PublishRelay<Void>()
    
    /// 다음 게시물 조회 호출
    fetchNextPostsTrigger
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchPosts()
      }
      .do(onNext: { self.nextCursor = $0.0 })
      .map { $0.1 }
      .bind(to: fetchedPosts)
      .disposed(by: disposeBag)
    
    /// 새로운 게시물 응답을 기존 게시물 배열에 추가 + 새로고침 애니메이션이 있다면 중단
    fetchedPosts
      .bind(with: self) { owner, newPosts in
        refreshCompleted.accept(())
        owner.appendPosts(newPosts)
      }
      .disposed(by: disposeBag)
    
    /// 유저의 판매자 권한 등록 여부 확인
    input.viewDidLoadEvent
      .map { UserInfoService.hasSellerAuthority }
      .bind(to: hasSellerAuthority)
      .disposed(by: disposeBag)
    
    /// 화면이 로드되면 게시물 요청
    input.viewDidLoadEvent
      .bind(to: fetchNextPostsTrigger)
      .disposed(by: disposeBag)
    
    /// 장바구니 상품 조회 호출
    input.viewDidLoadEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchCommercialPostsUsecase.fetchCartPosts()
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(to: cartPosts)
      .disposed(by: disposeBag)
    
    /// 마지막 상품의 이전 줄이 표시될 때, 페이지네이션
    input.showProductCellEvent
      .filter { $0.row >= self.posts.value.count - 2 }
      .map { _ in () }
      .bind(to: fetchNextPostsTrigger)
      .disposed(by: disposeBag)
    
    /// 상품 판매글 작성 화면 연결
    input.createPostTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showCreatePostView(posts: owner.posts)
      }
      .disposed(by: disposeBag)
    
    /// 장바구니 탭 이벤트 화면 연결
    input.cartTapEvent
      .bind(with: self) { owner, _ in
        owner.coordinator?.showCartPostListView(posts: owner.posts, cartPosts: owner.cartPosts)
      }
      .disposed(by: disposeBag)
    
    /// 포스트 셀 탭 이벤트 > 상품 디테일 화면 연결
    input.postCollectionCellSelectedEvent
      .bind(with: self) { owner, post in
        owner.coordinator?.showPostDetailView(post: post, originalPosts: owner.posts, cartPosts: owner.cartPosts)
      }
      .disposed(by: disposeBag)
    
    /// 새로고침 > 커서, 게시물 리스트 초기화 > 게시물 요청
    input.scrollRefeshEvent
      .do(onNext: { _ in
        self.refreshPosts()
      })
      .bind(to: fetchNextPostsTrigger)
      .disposed(by: disposeBag)
    
    return Output(
      hasSellerAuthority: hasSellerAuthority.asDriver(onErrorJustReturn: false),
      posts: posts.asDriver(),
      cartPosts: cartPosts.asDriver(),
      refreshCompleted: refreshCompleted.asDriver(onErrorJustReturn: ())
    )
  }
  
  private func refreshPosts() {
    // 상태 초기화
    nextCursor = ""
    posts.accept([])
  }
  
  private func fetchPosts() -> Single<(CommercialPost.PostID, [CommercialPost])> {
    // 최근 커서가 마지막 커서 사인이면 스트림 종료
    guard nextCursor != Constant.Network.lastCursorSign else { return .never() }
    
    return fetchCommercialPostsUsecase.fetchPosts(nextCursor: nextCursor)
      .catch { error in
        self.coordinator?.showErrorAlert(error: error)
        
        return .just((self.nextCursor, []))
      }
  }
  
  private func appendPosts(_ newPosts: [CommercialPost]) {
    var mergedPosts = posts.value
    mergedPosts.append(contentsOf: newPosts)
    
    posts.accept(mergedPosts)
  }
}
