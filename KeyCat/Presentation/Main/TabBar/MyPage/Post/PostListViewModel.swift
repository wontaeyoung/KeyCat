//
//  PostListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvnet: PublishRelay<Void>
    let showProductCellEvent: PublishRelay<IndexPath>
    
    init(
      viewDidLoadEvnet: PublishRelay<Void> = .init(),
      showProductCellEvent: PublishRelay<IndexPath> = .init()
    ) {
      self.viewDidLoadEvnet = viewDidLoadEvnet
      self.showProductCellEvent = showProductCellEvent
    }
  }
  
  struct Output {
    let posts: Driver<[CommercialPost]>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let fetchCommercialPostUsecase: any FetchCommercialPostUsecase
  private let userID: CommercialPost.UserID
  private let postCase: PostCase
  
  private var nextCursor: CommercialPost.PostID = ""
  private let posts = BehaviorRelay<[CommercialPost]>(value: [])
  private let fetchedPosts = PublishRelay<[CommercialPost]>()
  
  // MARK: - Initializer
  init(
    fetchCommercialPostUsecase: any FetchCommercialPostUsecase,
    userID: CommercialPost.UserID,
    postCase: PostCase
  ) {
    self.fetchCommercialPostUsecase = fetchCommercialPostUsecase
    self.userID = userID
    self.postCase = postCase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    /// 새로운 게시물 응답을 기존 게시물 배열에 추가
    fetchedPosts
      .bind(with: self) { owner, newPosts in
        owner.appendPosts(newPosts)
      }
      .disposed(by: disposeBag)
    
    /// 상품 조회 로직 호출
    input.viewDidLoadEvnet
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchPosts()
      }
      .do(onNext: { self.nextCursor = $0.0 })
      .map { $0.1 }
      .bind(to: fetchedPosts)
      .disposed(by: disposeBag)
      
    /// 화면에 표시될 상품이 3개 남았을 때
    input.showProductCellEvent
      .filter { $0.row >= self.posts.value.count - 3 }
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchPosts()
      }
      .do(onNext: { self.nextCursor = $0.0 })
      .map { $0.1 }
      .bind(to: fetchedPosts)
      .disposed(by: disposeBag)
    
    return Output(posts: posts.asDriver())
  }
  
  private func fetchPosts() -> Single<(CommercialPost.PostID, [CommercialPost])> {
    // 최근 커서가 마지막 커서 사인이면 스트림 종료
    guard nextCursor != Constant.Network.lastCursorSign else { return .never() }
    
    let posts: Single<(CommercialPost.PostID, [CommercialPost])> = postCase == .createdBy
    ? fetchCommercialPostUsecase.fetchCommercialPostsFromUser(userID: userID, nextCursor: nextCursor)
    : fetchCommercialPostUsecase.fetchBookmarkPosts(nextCursor: nextCursor)
    
    return posts
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

extension PostListViewModel {
  
  enum PostCase: Int, CaseIterable {
    
    case createdBy
    case bookmark
    
    var title: String {
      switch self {
        case .createdBy:
          return "작성한 게시물"
        case .bookmark:
          return "북마크한 게시물"
      }
    }
  }
}
