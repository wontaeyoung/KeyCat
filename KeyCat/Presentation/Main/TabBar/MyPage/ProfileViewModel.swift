//
//  ProfileViewModel.swift
//  KeyCat
//
//  Created by 원태영 on 5/5/24.
//

import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModel {
  
  // MARK: - I / O
  struct Input {
    let viewDidLoadEvent: PublishRelay<Void>
    let tableCellTapEvent: PublishRelay<ProfileViewController.ProfileRow>
    let followTapEvent: PublishRelay<Void>
    
    init(
      viewDidLoadEvent: PublishRelay<Void> = .init(),
      tableCellTapEvent: PublishRelay<ProfileViewController.ProfileRow> = .init(),
      followTapEvent: PublishRelay<Void> = .init()
    ) {
      self.viewDidLoadEvent = viewDidLoadEvent
      self.tableCellTapEvent = tableCellTapEvent
      self.followTapEvent = followTapEvent
    }
  }
  
  struct Output {
    let profile: BehaviorRelay<Profile>
  }
  
  // MARK: - Property
  let disposeBag = DisposeBag()
  weak var coordinator: MyPageCoordinator?
  private let fetchProfileUsecase: any FetchProfileUsecase
  private let userInteractionUsecase: any UserInteractionUsecase
  
  private let userID: User.UserID
  private let myProfile: BehaviorRelay<Profile>
  
  // MARK: - Initializer
  init(
    userID: User.UserID,
    myProfile: BehaviorRelay<Profile>?,
    fetchProfileUsecase: any FetchProfileUsecase = FetchProfileUsecaseImpl(),
    userInteractionUsecase: any UserInteractionUsecase = UserInteractionUsecaseImpl()
  ) {
    self.userID = userID
    self.myProfile = myProfile ?? BehaviorRelay<Profile>(value: .empty)
    self.fetchProfileUsecase = fetchProfileUsecase
    self.userInteractionUsecase = userInteractionUsecase
  }
  
  // MARK: - Method
  func transform(input: Input) -> Output {
    
    let profile = BehaviorRelay<Profile>(value: .empty)
    
    profile
      .filter { $0.profileType == .mine }
      .bind(to: myProfile)
      .disposed(by: disposeBag)
  
    /// 화면 진입 이벤트 > 프로필 조회 호출
    input.viewDidLoadEvent
      .map { UserInfoService.isMyUserID(with: self.userID) }
      .withUnretained(self)
      .flatMap { owner, isMine in
        print("HERe", isMine)
        
        let profile: Single<Profile> = isMine 
        ? owner.fetchProfileUsecase.fetchMyProfile()
        : owner.fetchProfileUsecase.fetchOtherProfile(userID: self.userID)
        
        return profile
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(to: profile)
      .disposed(by: disposeBag)
    
    /// 프로필 셀 탭 이벤트 핸들링
    input.tableCellTapEvent
      .bind(with: self) { owner, row in
        owner.handleProfileRowTapEvent(with: row, profile: profile)
      }
      .disposed(by: disposeBag)
    
    /// 팔로우 탭 이벤트 핸들링
    input.followTapEvent
      .withLatestFrom(profile)
      .withUnretained(self)
      .flatMap { owner, profile in
        let profile = profile.isFollowing
        ? owner.userInteractionUsecase.unfollow(userID: profile.userID)
        : owner.userInteractionUsecase.follow(userID: profile.userID)
        
        return profile
          .catch {
            owner.coordinator?.showErrorAlert(error: $0)
            return .never()
          }
      }
      .bind(with: self) { owner, status in
        owner.updateFollowInProfile(status: status, otherProfileRelay: profile)
      }
      .disposed(by: disposeBag)
    
    return Output(
      profile: profile
    )
  }
  
  private func updateFollowInProfile(status: Bool, otherProfileRelay: BehaviorRelay<Profile>) {
    
    var myProfile = myProfile.value
    var otherProfile = otherProfileRelay.value
    
    if status {
      myProfile.following.append(makeUser(from: otherProfile))
      otherProfile.followers.append(makeUser(from: myProfile))
    } else {
      guard
        let myProfileIndex = otherProfile.followers.map({ $0.userID }).firstIndex(of: myProfile.userID),
        let otherProfileIndex = myProfile.following.map({ $0.userID }).firstIndex(of: otherProfile.userID)
      else {
        return
      }
      
      myProfile.following.remove(at: otherProfileIndex)
      otherProfile.followers.remove(at: myProfileIndex)
    }
    
    self.myProfile.accept(myProfile)
    otherProfileRelay.accept(otherProfile)
  }
  
  private func makeUser(from profile: Profile) -> User {
    return User(userID: profile.userID, nickname: profile.nickname, profileImageURLString: profile.profileImageURLString)
  }
  
  private func handleProfileRowTapEvent(with row: ProfileViewController.ProfileRow, profile: BehaviorRelay<Profile>) {
    switch row {
      case .writingPosts:
        break
      case .following:
        coordinator?.showFollowListView(profile: profile, myProfile: myProfile, followTab: .following)
      case .follower:
        coordinator?.showFollowListView(profile: profile, myProfile: myProfile, followTab: .follower)
      case .bookmark:
        break
      case .updateProfile:
        break
      case .withdraw:
        break
    }
  }
}
