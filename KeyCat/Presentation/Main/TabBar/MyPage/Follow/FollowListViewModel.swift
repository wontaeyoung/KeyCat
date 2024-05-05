//
//  FollowListViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class FollowListViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let followCellTapEvent: PublishRelay<User>
    
    init(
      followCellTapEvent: PublishRelay<User> = .init()
    ) {
      self.followCellTapEvent = followCellTapEvent
    }
  }
  
  struct Output {
    let profile: Driver<Profile>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let profile: BehaviorRelay<Profile>
  private let myProfile: BehaviorRelay<Profile>
  
  // MARK: - Initializer
  init(profile: BehaviorRelay<Profile>, myProfile: BehaviorRelay<Profile>) {
    self.profile = profile
    self.myProfile = myProfile
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
   
    input.followCellTapEvent
      .bind(with: self) { owner, user in
        owner.coordinator?.showMyProfileView(userID: user.userID)
      }
      .disposed(by: disposeBag)
    
    return Output(profile: profile.asDriver())
  }
}
