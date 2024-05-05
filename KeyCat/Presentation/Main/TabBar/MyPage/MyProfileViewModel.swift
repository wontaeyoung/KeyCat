//
//  MyProfileViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class MyProfileViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    let tableCellTapEvent: PublishRelay<MyProfileViewController.ProfileRow>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init(),
      tableCellTapEvent: PublishRelay<MyProfileViewController.ProfileRow> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
      self.tableCellTapEvent = tableCellTapEvent
    }
  }
  
  struct Output {
    let profile: BehaviorRelay<Profile>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let fetchProfileUsecase: any FetchProfileUsecase
  
  // MARK: - Initializer
  init(
    fetchProfileUsecase: any FetchProfileUsecase = FetchProfileUsecaseImpl()
  ) {
    self.fetchProfileUsecase = fetchProfileUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let profile = BehaviorRelay<Profile>(value: .empty)
    
    /// 화면 진입 이벤트 > 프로필 조회 호출
    input.viewDidLoadEvent
      .withUnretained(self)
      .flatMap { owner, _ in
        return owner.fetchProfileUsecase.fetchMyProfile()
      }
      .bind(to: profile)
      .disposed(by: disposeBag)
    
    input.tableCellTapEvent
      .bind(with: self) { owner, row in
        owner.handleProfileRowTapEvent(with: row, profile: profile)
      }
      .disposed(by: disposeBag)
    
    return Output(
      profile: profile
    )
  }
  
  private func handleProfileRowTapEvent(with row: MyProfileViewController.ProfileRow, profile: BehaviorRelay<Profile>) {
    switch row {
      case .myPosts:
        break
      case .following:
        coordinator?.showFollowListView(profile: profile, followTab: .following)
      case .follower:
        coordinator?.showFollowListView(profile: profile, followTab: .follower)
      case .bookmark:
        break
      case .updateProfile:
        break
      case .withdraw:
        break
    }
  }
}
