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
    
  }
  
  struct Output {
    let profile: Driver<Profile>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let profile: BehaviorRelay<Profile>
  
  // MARK: - Initializer
  init(profile: BehaviorRelay<Profile>) {
    let profile = profile
    var profileValue = profile.value
    profileValue.folllowing = (1...15).map {
      User(userID: "id\($0)", nickname: "닉네임 \($0)", profileImageURLString: "")
    }
    
    profileValue.followers = (1...10).map {
      User(userID: "id\($0)", nickname: "이름 \($0)", profileImageURLString: "")
    }
    profile.accept(profileValue)
    
    self.profile = profile
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
   
    return Output(profile: profile.asDriver())
  }
}
